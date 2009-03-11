class CreateFantasies < ActiveRecord::Migration
  def self.up
    create_table :fantasies do |t|
      t.text :description
      

      t.timestamps
    end
  end

  def self.down
    drop_table :fantasies
  end
end
