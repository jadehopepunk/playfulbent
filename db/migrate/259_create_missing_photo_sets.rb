class CreateMissingPhotoSets < ActiveRecord::Migration
  def self.up
    for profile in Profile.find(:all, :conditions => "id NOT IN (SELECT profile_id FROM photo_sets)")
      profile.photo_sets.create(:title => "#{profile.user.name}'s Photos")      
    end
  end

  def self.down
  end
end
