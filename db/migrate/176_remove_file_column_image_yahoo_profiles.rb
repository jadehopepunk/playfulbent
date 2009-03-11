class RemoveFileColumnImageYahooProfiles < ActiveRecord::Migration
  def self.up
    remove_column :yahoo_profiles, :image
  end

  def self.down
    add_column :yahoo_profiles, :image, :string
  end
end
