class AddScrapedAtToYahooProfiles < ActiveRecord::Migration
  def self.up
    add_column :yahoo_profiles, :scraped_at, :datetime
  end

  def self.down
    remove_column :yahoo_profiles, :scraped_at
  end
end
