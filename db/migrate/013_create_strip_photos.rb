class CreateStripPhotos < ActiveRecord::Migration
  def self.up
      create_table :strip_photos do |table|
        table.column(:strip_show_id,  :integer)
        table.column(:image,  :text)
      end
  end

  def self.down
      drop_table :strip_photos
  end
end
