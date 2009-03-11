class AddCreatedOnToPageVersionFollowers < ActiveRecord::Migration
  def self.up
    add_column :page_version_followers, :created_on, :datetime
    execute "UPDATE page_version_followers SET created_on = NOW()"
  end

  def self.down
    remove_column :page_version_followers, :created_on
  end
end
