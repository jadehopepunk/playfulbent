class AddDareChallengeIdToDareResponses < ActiveRecord::Migration
  def self.up
    add_column :dare_responses, :dare_challenge_id, :integer
  end

  def self.down
    remove_column :dare_responses, :dare_challenge_id
  end
end
