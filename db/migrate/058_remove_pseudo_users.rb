class RemovePseudoUsers < ActiveRecord::Migration
  def self.up
    execute "DELETE FROM users WHERE is_pseudo = 1"
  end

  def self.down
  end
end
