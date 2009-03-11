class RemoveMessageDuplicates < ActiveRecord::Migration
  def self.up
    for message in MailingListMessage.find(:all, :order => 'created_at ASC')
      if MailingListMessage.exists?(["message_identifier = ? && id != ?", message.message_identifier, message.id])
        message.destroy
      end
    end
  end

  def self.down
  end
end
