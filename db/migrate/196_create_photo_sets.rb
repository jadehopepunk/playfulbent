class CreatePhotoSets < ActiveRecord::Migration
  def self.up
    create_table :photo_sets do |t|
      t.column :profile_id, :integer
      t.column :title, :string
      t.column :position, :integer
      t.column :viewable_by, :string
      t.column :minimum_ticks, :integer
    end
    
    add_index :photo_sets, :profile_id
  end

  def self.down
    drop_table :photo_sets
  end
end
