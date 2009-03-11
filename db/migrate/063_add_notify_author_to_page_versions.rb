class AddNotifyAuthorToPageVersions < ActiveRecord::Migration
  def self.up
    add_column :page_versions, :should_notify_author, :boolean, :default => true
  end

  def self.down
    remove_column :page_versions, :should_notify_author
  end
end
