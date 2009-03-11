class AddViewableOnYahooToYahooProfiles < ActiveRecord::Migration
  def self.up
    add_column :yahoo_profiles, :viewable_on_yahoo, :boolean, :default => false
  end

  def self.down
    remove_column :yahoo_profiles, :viewable_on_yahoo
  end
end
