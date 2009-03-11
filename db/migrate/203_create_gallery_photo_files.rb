class CreateGalleryPhotoFiles < ActiveRecord::Migration
  def self.up
    create_table :gallery_photo_files do |t|
      t.column :size, :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :height, :integer
      t.column :width, :integer
      t.column :parent_id, :integer
      t.column :thumbnail, :string
      
      t.column :gallery_photo_id, :integer
      
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    add_index :gallery_photo_files, :parent_id
    add_index :gallery_photo_files, :gallery_photo_id
  end

  def self.down
    drop_table :gallery_photo_files
  end
end
