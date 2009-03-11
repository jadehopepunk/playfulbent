class SetCreatedOnForCurrentUsers < ActiveRecord::Migration
  def self.up
    for user in User.find(:all)
      user.created_on = Time.now
      user.created_on = user.strip_shows.first.published_at unless user.strip_shows.empty?
      user.save
    end
  end

  def self.down
  end
end
