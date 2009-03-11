class CopyGenderIdFromProfilesToUsers < ActiveRecord::Migration
  def self.up
    for profile in Profile.find(:all, :conditions => "gender_id != '' AND gender_id IS NOT NULL")
      execute "UPDATE users SET gender_id = #{profile.gender_id} WHERE id = #{profile.user_id}"
    end
  end

  def self.down
  end
end
