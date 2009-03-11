class RemovePopularityFromRelationshipTypes < ActiveRecord::Migration
  def self.up
    remove_column :relationship_types, :popularity
  end

  def self.down
    add_column :relationship_types, :popularity, :integer
  end
end
