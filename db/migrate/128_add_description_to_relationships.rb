class AddDescriptionToRelationships < ActiveRecord::Migration
  def self.up
    add_column :relationships, :description, :text
  end

  def self.down
    remove_column :relationships, :description
  end
end
