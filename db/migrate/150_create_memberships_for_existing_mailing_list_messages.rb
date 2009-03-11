class CreateMembershipsForExistingMailingListMessages < ActiveRecord::Migration
  def self.up
    for message in MailingListMessage.find(:all)
      group = message.group
      profile = message.sender_external_profile
      if group && profile
        group.make_member(profile)
      end
    end
  end

  def self.down
  end
end
