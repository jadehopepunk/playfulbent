class AddSenderProfileIdToMailingListMessages < ActiveRecord::Migration
  def self.up
    add_column :mailing_list_messages, :sender_profile_id, :integer
  end

  def self.down
    remove_column :mailing_list_messages, :sender_profile_id
  end
end
