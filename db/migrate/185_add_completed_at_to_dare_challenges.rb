class AddCompletedAtToDareChallenges < ActiveRecord::Migration
  def self.up
    add_column :dare_challenges, :completed_at, :datetime
  end

  def self.down
    remove_column :dare_challenges, :completed_at
  end
end
