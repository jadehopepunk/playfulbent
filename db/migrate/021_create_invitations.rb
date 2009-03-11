class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.column :name, :string
      t.column :email_address, :string
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :invitations
  end
end
