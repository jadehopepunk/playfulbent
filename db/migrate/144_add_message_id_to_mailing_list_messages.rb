class AddMessageIdToMailingListMessages < ActiveRecord::Migration
  def self.up
    add_column :mailing_list_messages, :message_identifier, :string
  end

  def self.down
    remove_column :mailing_list_messages, :message_identifier
  end
end
