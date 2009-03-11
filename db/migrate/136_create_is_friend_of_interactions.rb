class CreateIsFriendOfInteractions < ActiveRecord::Migration
  def self.up
    for relationship in Relationship.find(:all)
      InteractionIsFriendOf.ensure_created(relationship.subject, relationship.user)
    end
  end

  def self.down
  end
end
