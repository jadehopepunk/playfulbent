class AddTypeColumnToPhotoSets < ActiveRecord::Migration
  def self.up
    add_column :photo_sets, :type, :string
  end

  def self.down
    remove_column :photo_sets, :type
  end
end
