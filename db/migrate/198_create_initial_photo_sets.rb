class CreateInitialPhotoSets < ActiveRecord::Migration
  def self.up
    for profile in Profile.find(:all)
      photo_set = profile.photo_sets.create(:title => "#{profile.user.name}'s Photos")
      execute "UPDATE gallery_photos SET photo_set_id = #{photo_set.id} WHERE profile_id = #{profile.id}"
    end
  end

  def self.down
    PhotoSet.delete_all
  end
end
