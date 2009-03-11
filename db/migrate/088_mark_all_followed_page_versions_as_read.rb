class MarkAllFollowedPageVersionsAsRead < ActiveRecord::Migration
  def self.up
    for version in PageVersion.find(:all)
      for follower in version.followers
        version.mark_as_read_by(follower)
      end
    end
  end

  def self.down
  end
end
