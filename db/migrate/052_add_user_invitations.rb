class AddUserInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :type, :string
    add_column :invitations, :recipient_id, :integer
  end

  def self.down
    remove_column :invitations, :type
    remove_column :invitations, :recipient_id
  end
end
