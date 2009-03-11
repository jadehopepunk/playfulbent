class AddTaggingsIndexes < ActiveRecord::Migration
  def self.up
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type]
  end

  def self.down
    remove_index :taggings, :tag_id
    remove_index :taggings, [:taggable_id, :taggable_type]
  end
end
