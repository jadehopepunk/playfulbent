class AddPositionToRelationshipTypes < ActiveRecord::Migration
  def self.up
    add_column :relationship_types, :position, :integer
  end

  def self.down
    remove_column :relationship_types, :position
  end
end
