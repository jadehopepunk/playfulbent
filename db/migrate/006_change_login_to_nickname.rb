class ChangeLoginToNickname < ActiveRecord::Migration
  def self.up
    rename_column(:users, :login, :nick)
  end

  def self.down
    rename_column(:users, :nick, :login)
  end
end
