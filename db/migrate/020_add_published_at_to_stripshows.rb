require 'strip_show.rb'

class AddPublishedAtToStripshows < ActiveRecord::Migration
  def self.up
    add_column :strip_shows, :published_at, :datetime
    StripShow.find(:all).each do |strip_show|
      strip_show.published_at = Time.now
      strip_show.save
    end
  end

  def self.down
    remove_column :strip_shows, :published_at
  end
end
