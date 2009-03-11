class AddTypeColumnToDareResponses < ActiveRecord::Migration
  def self.up
    add_column :dare_responses, :type, :string
    execute "UPDATE dare_responses SET type = 'DareResponse'"
  end

  def self.down
    remove_column :dare_responses, :type
  end
end
