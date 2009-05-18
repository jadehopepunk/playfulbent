class CreateDareGames < ActiveRecord::Migration
  def self.up
    create_table :dare_games do |t|
      t.integer :creator_id, :max_players
      t.string :name
      t.text :instructions
      t.timestamps
    end
  end

  def self.down
    drop_table :dare_games
  end
end
