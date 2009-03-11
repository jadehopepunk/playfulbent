class AddScrapedAtToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :scraped_at, :datetime
  end

  def self.down
    remove_column :groups, :scraped_at
  end
end
