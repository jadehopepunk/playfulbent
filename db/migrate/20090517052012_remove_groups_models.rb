class RemoveGroupsModels < ActiveRecord::Migration
  def self.up
    drop_table :yahoo_profiles
    drop_table :mailing_list_messages
    drop_table :external_profile_photos
    drop_table :groups
    drop_table :group_memberships
  end

  def self.down
  end
end
