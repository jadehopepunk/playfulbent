class CreateExternalProfilePhotos < ActiveRecord::Migration
  def self.up
    create_table :external_profile_photos do |t|
      t.column :parent_id,  :integer
      t.column :content_type, :string
      t.column :filename, :string    
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.column :yahoo_profile_id, :integer
    end
    
    add_index :external_profile_photos, :yahoo_profile_id
  end

  def self.down
    drop_table :external_profile_photos
  end
end
