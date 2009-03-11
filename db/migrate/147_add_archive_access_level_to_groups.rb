class AddArchiveAccessLevelToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :archive_access_level, :string
  end

  def self.down
    remove_column :groups, :archive_access_level
  end
end
