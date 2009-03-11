class AddEmailSenderIdToEmails < ActiveRecord::Migration
  def self.up
    add_column :emails, :email_sender_id, :integer
  end

  def self.down
    remove_column :emails, :email_sender_id
  end
end
