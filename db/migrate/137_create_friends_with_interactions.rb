class CreateFriendsWithInteractions < ActiveRecord::Migration
  def self.up
    for relationship in Relationship.find(:all)
      InteractionFriendsWith.ensure_created(relationship.user, relationship.subject)
    end
  end

  def self.down
  end
end
