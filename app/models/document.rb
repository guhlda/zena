=begin rdoc
A Document is a node with a file.

=== File storage

There can be one file per version but when a new version created without a new file, the new version uses the same file as the original:

 original version -------> file1   (this file cannot be changed)
                            /
 new version      ---------/       (we can add a new file here)

We cannot change the original file but we can add a new file to the new version: 

 original version -------> file1   (this file can now be changed)
 
 new version      -------> file2   (this file can be changed too)

This is to prevent a published file (file1 for example) to be changed during a redaction.

File data is kept in a directory in +sites/<host>/data/<ext>/<version_id>/<filename>+. This makes it possible to retrieve the data in case the database goes havoc.

=== Version

The version class used by documents is the DocumentVersion.

=== Content

Content (file data) is managed by the DocumentContent. This class is responsible for storing the file and retrieving the data. It provides the following attributes to the Document :

c_size::  file size      
c_ext::   file extension 
c_content_type:: file content-type
=end
# should be a sub-class of Node, not Page (#184). Write a migration, fix fixtures and test.
class Document < Node
  
  attr_public        :filename
  
  before_validation :document_before_validation
  
  class << self
    
    def version_class
      DocumentVersion
    end
    
    alias o_new new
    
    # Return a new Document or a sub-class of Document depending on the file's content type. Returns a TextDocument if there is no file.
    def new(attrs = {})
      
      scope = self.scoped_methods[0] || {}
      klass = self
      attrs = attrs.stringify_keys
      file  = attrs['c_file'] || ((attrs['version_attributes'] || {})['content_attributes'] || {})['file']
      if file && file.respond_to?(:content_type)
        content_type = file.content_type
      elsif ct = attrs['c_content_type'] || ((attrs['version_attributes'] || {})['content_attributes'] || {})['content_type']
        content_type = ct
      elsif attrs['name'] =~ /^.*\.(\w+)$/ && types = EXT_TO_TYPE[$1.downcase]
        content_type = types[0]
      end
      
      if content_type
        if Image.accept_content_type?(content_type)
          klass = Image
        elsif Template.accept_content_type?(content_type)
          klass = Template
        elsif TextDocument.accept_content_type?(content_type)
          klass = TextDocument
        end
      elsif self == Document
        # no content_type means no file. Only TextDocuments can be created without files
        content_type = 'text/plain'
        klass = TextDocument
      end
      
      attrs['c_content_type'] = content_type
      
      if klass != self
        klass.with_scope(scope) { klass.o_new(attrs) }
      else
        klass.o_new(attrs)
      end
    end
    
    # Class list to which this class can change to
    def change_to_classes_for_form
      classes_for_form(:class => 'Document', :without => 'Image')
    end
  end
  
  # Return true if the document is an image.
  def image?
    kind_of?(Image)
  end
  
  # Return the document's public filename using the name and the file extension.
  def filename
    "#{name}.#{version.content.ext}"
  end
  
  def rootpath
    super + ".#{version.content.ext}"
  end
  
  private
  
    # Make sure name is unique
    def document_before_validation
      
      base = self[:name]
      base = version.title if base.blank?
      if base.blank? && file = version.content.file
        base = file.original_filename
      end

      if base
        if base =~ /(.*)\.(\w+)$/
          self.name = $1 if new_record?
          self.version.content.ext ||= $2
        else
          self.name = base if new_record?
        end
        if version.title.to_s =~ /\A(.*)\.#{version.content.ext}$/i
          version.title = $1
        end
      end
      
      # we are in a scope, we cannot just use the normal validates_... 
      # FIXME: remove 'with_exclusive_scope' once scopes are clarified and removed from 'secure'
      Node.send(:with_exclusive_scope) do
        if new_record? 
          cond = ["name = ? AND parent_id = ? AND kpath LIKE 'ND%'",              self[:name], self[:parent_id]]
        else
          cond = ["name = ? AND parent_id = ? AND kpath LIKE 'ND%' AND id != ? ", self[:name], self[:parent_id], self[:id]]
        end
        taken_name = Node.find(:all, :conditions=>cond, :order=>"LENGTH(name) DESC", :limit => 1)
        if taken_name = taken_name[0]
          if taken_name =~ /^#{self[:name]}-(\d)/
            self[:name] = "#{self[:name]}-#{$1.to_i + 1}"
          else
            self[:name] = "#{self[:name]}-1"
          end
        end
      end
    end
end