class AddTimestampToTaggings < ActiveRecord::Migration
  def self.up
    add_column :taggings, :created_at, :datetime
    execute "UPDATE taggings SET created_at = NOW()"
  end

  def self.down
    remove_column :taggings, :created_at
  end
end
