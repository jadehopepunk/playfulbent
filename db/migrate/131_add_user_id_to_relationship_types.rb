class AddUserIdToRelationshipTypes < ActiveRecord::Migration
  def self.up
    add_column :relationship_types, :user_id, :integer
  end

  def self.down
    remove_column :relationship_types, :user_id, :integer
  end
end
