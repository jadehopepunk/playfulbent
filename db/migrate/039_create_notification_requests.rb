class CreateNotificationRequests < ActiveRecord::Migration
  def self.up
    create_table :notification_requests do |t|
      t.column :email_address, :string
      t.column :created_on, :datetime
    end
  end

  def self.down
    drop_table :notification_requests
  end
end
