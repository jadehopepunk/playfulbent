class AddStateToDareGames < ActiveRecord::Migration
  def self.up
    add_column :dare_games, :state, :string, :length => 20, :default => 'open'
  end

  def self.down
    remove_column :dare_games, :state
  end
end
