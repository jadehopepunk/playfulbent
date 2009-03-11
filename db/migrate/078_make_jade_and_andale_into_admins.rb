class MakeJadeAndAndaleIntoAdmins < ActiveRecord::Migration
  def self.up
    "UPDATE users SET is_admin = 1 WHERE id = 1 OR id = 2"
  end

  def self.down
    "UPDATE users SET is_admin = 0"
  end
end
