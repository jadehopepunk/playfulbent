class RenameDareResponseToBaseDareResponses < ActiveRecord::Migration
  def self.up
    rename_table :dare_responses, :base_dare_responses
  end

  def self.down
    rename_table :base_dare_responses, :dare_responses
  end
end
