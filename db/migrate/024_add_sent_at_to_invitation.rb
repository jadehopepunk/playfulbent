require 'invitation.rb'

class AddSentAtToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :sent_on, :date
    Invitation.find(:all).each do |invitation|
      invitation.sent_on = Date.today
      invitation.save
    end
  end

  def self.down
    remove_column :invitations, :sent_at
  end
end
