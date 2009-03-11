class CreateActionShots < ActiveRecord::Migration
  def self.up
    create_table :action_shots do |t|
      t.column :parent_id,  :integer
      t.column :content_type, :string
      t.column :filename, :string    
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.column :review_id, :integer
    end
    
    add_index :action_shots, :review_id
  end

  def self.down
    drop_table :action_shots
  end
end
