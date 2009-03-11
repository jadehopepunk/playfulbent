class AddRejectedAtToDareChallenges < ActiveRecord::Migration
  def self.up
    add_column :dare_challenges, :rejected_at, :datetime
  end

  def self.down
    remove_column :dare_challenges, :rejected_at
  end
end
