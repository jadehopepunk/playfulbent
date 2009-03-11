class AddPhotosDareRatios < ActiveRecord::Migration
  def self.up
    add_column :tag_ranks, :gallery_photo_count, :integer
    add_column :tag_ranks, :gallery_photo_ratio, :integer
    
    add_index :tag_ranks, :gallery_photo_count
  end

  def self.down
    remove_index :tag_ranks, :gallery_photo_count
    remove_column :tag_ranks, :gallery_photo_ratio
    remove_column :tag_ranks, :gallery_photo_count
  end
end
