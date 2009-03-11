class AddImageToYahooProfiles < ActiveRecord::Migration
  def self.up
    add_column :yahoo_profiles, :image, :string
  end

  def self.down
    remove_column :yahoo_profiles, :image
  end
end
