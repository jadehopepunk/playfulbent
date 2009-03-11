class AddCreatorToFantasy < ActiveRecord::Migration
  def self.up
    add_column :fantasies, :creator_id, :integer
  end

  def self.down
    remove_column :fantasies, :creator_id
  end
end
