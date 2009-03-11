class CreateFantasyActors < ActiveRecord::Migration
  def self.up
    create_table :fantasy_actors do |t|
      t.integer :user_id, :fantasy_role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :fantasy_actors
  end
end
