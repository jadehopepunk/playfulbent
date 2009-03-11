class RemoveShouldNotifyAuthorFromPageVersions < ActiveRecord::Migration
  def self.up
    remove_column :page_versions, :should_notify_author
  end

  def self.down
    add_column :page_versions, :should_notify_author, :boolean, :default => true
  end
end
