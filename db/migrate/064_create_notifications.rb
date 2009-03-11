class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.column :receiver_id, :integer
      t.column :mailer_action, :string
      t.column :content_id, :integer
      t.column :content_type, :string
      t.column :created_on, :datetime
    end
  end

  def self.down
    drop_table :notifications
  end
end
