class CreatePermalinksForUsers < ActiveRecord::Migration
  def self.up
    for user in User.find(:all)
      user.calculate_permalink_from_nick
      user.save!
    end
  end

  def self.down
    execute "UPDATE users SET permalink = NULL"
  end
end
