class CreateForms < ActiveRecord::Migration
  def self.up
    
    add_column 'nodes', 'dgroup_id', :integer
    
    create_table('form_seizures', :options => 'type=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci') do |t|
      t.column 'user_id', :integer, :default => 0, :null => false
      t.column 'created_at', :datetime
      t.column 'updated_at', :datetime
      t.column 'form_id', :integer
    end
    
    create_table('form_lines', :options => 'type=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci') do |t|
      t.column 'seizure_id', :integer
      t.column 'key', :string
      t.column 'value', :string, :limit=>255
    end
  end

  def self.down
    drop_table 'form_lines'
    drop_table 'form_seizures'
    remove_column 'nodes', 'dgroup_id'
  end
end
