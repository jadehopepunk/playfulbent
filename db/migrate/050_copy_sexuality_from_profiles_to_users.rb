class CopySexualityFromProfilesToUsers < ActiveRecord::Migration
  def self.up
    for profile in Profile.find(:all)
      profile.user.likes_boys = profile.likes_boys
      profile.user.likes_girls = profile.likes_girls
      profile.user.save!
    end
  end

  def self.down
  end
end
