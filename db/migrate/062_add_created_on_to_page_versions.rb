class AddCreatedOnToPageVersions < ActiveRecord::Migration
  def self.up
    add_column :page_versions, :created_on, :datetime
    execute "UPDATE page_versions SET created_on = NOW()"
  end

  def self.down
    remove_column :page_versions, :created_on
  end
end
