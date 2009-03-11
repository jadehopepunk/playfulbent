class RenameRelationshipNameIdToRelationshipTypeId < ActiveRecord::Migration
  def self.up
    rename_column :relationships, :relationship_name_id, :relationship_type_id
  end

  def self.down
    rename_column :relationships, :relationship_type_id, :relationship_name_id
  end
end
