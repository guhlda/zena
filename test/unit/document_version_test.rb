require 'test_helper'

class DocumentVersionTest < Zena::Unit::TestCase
  
  def test_content
    v = versions(:water_pdf_en)
    assert_equal DocumentContent, v.content_class
    assert_kind_of DocumentContent, v.content
    assert_equal 'water', v.content.name
  end
end
