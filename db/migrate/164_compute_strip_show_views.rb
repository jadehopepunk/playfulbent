class ComputeStripShowViews < ActiveRecord::Migration
  def self.up
    for strip_photo_view in StripPhotoView.find(:all)
      strip_photo_view.send(:update_strip_show_views)
    end
  end

  def self.down
  end
end
