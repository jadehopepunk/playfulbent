class CreatePageVersionReadings < ActiveRecord::Migration
  def self.up
    create_table :page_version_readings do |t|
      t.column :page_version_id, :integer
      t.column :story_id, :integer
      t.column :user_id, :integer
      t.column :created_at, :datetime
    end
    
    add_index :page_version_readings, [:story_id, :user_id]
  end

  def self.down
    drop_table :page_version_readings
  end
end
