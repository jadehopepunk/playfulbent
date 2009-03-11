class ReplaceNicknameUnderscoresWithSpaces < ActiveRecord::Migration
  def self.up
    execute "UPDATE users SET nick = REPLACE(nick, '_', ' ')"
  end

  def self.down
  end
end
