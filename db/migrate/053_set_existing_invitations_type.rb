class SetExistingInvitationsType < ActiveRecord::Migration
  def self.up
    execute "UPDATE invitations SET type = 'ExternalInvitation'"
  end

  def self.down
  end
end
