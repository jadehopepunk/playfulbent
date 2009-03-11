class UnpublishProfilesForDummyUsers < ActiveRecord::Migration
  def self.up
    User.find_each(:conditions => "nick IS NULL OR nick = ''") do |user|
      profile = user.profile
      if profile && profile.published
        profile.published = false
        profile.save!
      end
     end
  end

  def self.down
  end
end
