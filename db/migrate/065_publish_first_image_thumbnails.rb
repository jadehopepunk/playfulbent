class PublishFirstImageThumbnails < ActiveRecord::Migration
  def self.up
    for show in StripShow.find(:all, :conditions => "published_at IS NOT NULL")
      show.strip_photos.first.publish unless show.strip_photos.first.nil?
    end
  end

  def self.down
  end
end
