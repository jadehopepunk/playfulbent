class CreateEmailSenders < ActiveRecord::Migration
  def self.up
    create_table :email_senders do |t|
      t.string :address
      t.timestamps
    end
  end

  def self.down
    drop_table :email_senders
  end
end
