class AddUpdatedAtToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :updated_at, :datetime
    execute "UPDATE stories SET updated_at = NOW()"
  end

  def self.down
    remove_column :stories, :updated_at
  end
end
