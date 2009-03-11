class AddPositionToStripPhotos < ActiveRecord::Migration
  def self.up
    add_column(:strip_photos, :position, :integer)
  end

  def self.down
    remove_column(:strip_photos, :position)
  end
end
