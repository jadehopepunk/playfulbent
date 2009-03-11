class CreateEmailSendersForEmails < ActiveRecord::Migration
  def self.up
    Email.find_each do |email|
      email.send(:sender_address=, email.send(:sender_addr).address) if email.send(:sender_addr)
      email.save!
    end
  end

  def self.down
  end
end
