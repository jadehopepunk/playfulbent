class CreateStripPhotoViews < ActiveRecord::Migration
  def self.up
    create_table :strip_photo_views do |table|
      table.column(:id,  :integer)
      table.column(:strip_photo_id,  :integer)
      table.column(:user_id,  :integer)
    end
  end

  def self.down
    drop_table :strip_photo_views
  end
end
