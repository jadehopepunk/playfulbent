class CreateMessageReadings < ActiveRecord::Migration
  def self.up
    create_table :message_readings do |t|
      t.column :user_id, :integer
      t.column :message_id, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :message_readings
  end
end
