class RenameRelationshipNamesToRelationshipTypes < ActiveRecord::Migration
  def self.up
    rename_table :relationship_names, :relationship_types
  end

  def self.down
    rename_table :relationship_types, :relationship_names
  end
end
