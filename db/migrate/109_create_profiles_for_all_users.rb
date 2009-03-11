class CreateProfilesForAllUsers < ActiveRecord::Migration
  def self.up
    for user in User.find(:all)
      user.create_profile unless user.profile
    end
  end

  def self.down
  end
end
