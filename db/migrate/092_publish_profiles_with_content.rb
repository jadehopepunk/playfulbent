class PublishProfilesWithContent < ActiveRecord::Migration
  def self.up
    execute "UPDATE profiles SET published = 0"
    
    for profile in Profile.find(:all)
      if !profile.tags.empty? || !profile.avatar.nil? || !profile.welcome_text.blank?
        profile.ensure_published
      end
    end
  end

  def self.down
  end
end
