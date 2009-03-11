class CreateTagIndexes < ActiveRecord::Migration
  def self.up
    add_index :taggings, :taggable_type
    add_index :tags, :name
  end

  def self.down
    remove_index :taggings, :taggable_type
    remove_index :tags, :name
  end
end
