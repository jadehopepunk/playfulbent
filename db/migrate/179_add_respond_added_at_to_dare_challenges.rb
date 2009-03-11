class AddRespondAddedAtToDareChallenges < ActiveRecord::Migration
  def self.up
    add_column :dare_challenges, :response_added_at, :datetime
  end

  def self.down
    remove_column :dare_challenges, :response_added_at
  end
end
