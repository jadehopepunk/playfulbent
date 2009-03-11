class CreateCommentReadings < ActiveRecord::Migration
  def self.up
    create_table :comment_readings do |t|
      t.column :comment_id, :integer
      t.column :user_id, :integer
      t.column :created_on, :datetime
    end
  end

  def self.down
    drop_table :comment_readings
  end
end
