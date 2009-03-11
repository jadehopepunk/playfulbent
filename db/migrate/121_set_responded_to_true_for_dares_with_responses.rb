class SetRespondedToTrueForDaresWithResponses < ActiveRecord::Migration
  def self.up
    execute "UPDATE dares SET responded_to = 1 WHERE id IN (SELECT dare_id FROM dare_responses)"
  end

  def self.down
  end
end
