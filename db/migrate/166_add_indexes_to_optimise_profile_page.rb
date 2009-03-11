class AddIndexesToOptimiseProfilePage < ActiveRecord::Migration
  def self.up
    add_index :sponsorships, :user_id
    add_index :interactions, :actor_id
    add_index :interactions, :subject_id
    add_index :avatars, :profile_id
    add_index :interests, :profile_id
    add_index :kinks, :profile_id
  end

  def self.down
    remove_index :sponsorships, :user_id
    remove_index :interactions, :actor_id
    remove_index :interactions, :subject_id
  end
end
