class RenameSentAtToCreatedOn < ActiveRecord::Migration
  def self.up
    rename_column :invitations, :sent_on, :created_on
  end

  def self.down
    rename_column :invitations, :created_on, :sent_on
  end
end
