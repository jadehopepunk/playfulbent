class CreateGalleryPhotos < ActiveRecord::Migration
  def self.up
    create_table :gallery_photos do |t|
      t.column :image, :string
      t.column :profile_id, :integer
      t.column :created_on, :datetime
    end
  end

  def self.down
    drop_table :gallery_photos
  end
end
