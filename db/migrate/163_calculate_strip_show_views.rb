class CalculateStripShowViews < ActiveRecord::Migration
  def self.up
    for strip_show in StripShow.find(:all, :conditions => {:finished => 1})
      for user in User.find(:all)
        max_position = StripPhoto.maximum(:position, :include => :strip_photo_views, :conditions => ["strip_photo_views.user_id = ? AND strip_photos.strip_show_id = ?", user.id, strip_show.id]) || 0
        if max_position
          show_view = StripShowView.new(:strip_show_id => strip_show.id, :user_id => user.id, :max_position_viewed => max_position)
          show_view.save!
        end
      end
    end
  end

  def self.down
  end
end
