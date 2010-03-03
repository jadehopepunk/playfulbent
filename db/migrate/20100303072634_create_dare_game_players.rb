class CreateDareGamePlayers < ActiveRecord::Migration
  def self.up
    create_table :dare_game_players do |t|
      t.integer :dare_game_id, :user_id
      t.timestamps
    end
    
    add_index :dare_game_players, :dare_game_id
    add_index :dare_game_players, :user_id
  end

  def self.down
    drop_table :dare_game_players
  end
end
