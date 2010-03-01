# == Schema Information
#
# Table name: strip_photo_views
#
#  id             :integer(4)      not null, primary key
#  strip_photo_id :integer(4)
#  user_id        :integer(4)
#

class StripPhotoView < ActiveRecord::Base
  belongs_to :strip_photo
  belongs_to :viewer, :class_name => 'User', :foreign_key => 'user_id'
  validates_presence_of :strip_photo_id, :user_id
  
  after_create :update_strip_show_views, :ensure_interaction_created
  after_destroy :ensure_interaction_still_valid

  def self.exists_for_photo_and_user(photo, user)
    find_for_photo_and_user(photo, user) != nil
  end

  def self.find_for_photo_and_user(photo, user)
    find(:first, :conditions => ["strip_photo_id = ? and user_id = ?", photo.id, user.id])
  end

  def self.create_for_photo_and_user(photo, user)
    view = StripPhotoView.new
    view.strip_photo = photo
    view.viewer = user
    view.save
  end
  
  def self.ensure_exists_for(photo, user)
    StripPhotoView.create_for_photo_and_user(photo, user) unless StripPhotoView.exists_for_photo_and_user(photo, user)
  end
  
protected

  def update_strip_show_views
    StripShowView.update_max_position(strip_photo.strip_show, viewer, strip_photo.position)
    true
  end

  def ensure_interaction_created
    InteractionViewStripshow.ensure_created(viewer, strip_photo.user) if strip_photo.last?
    InteractionShowStripshow.ensure_created(strip_photo.user, viewer) if strip_photo.last?
    true
  end
  
  def ensure_interaction_still_valid
    InteractionViewStripshow.ensure_still_valid(viewer, strip_photo.user) if strip_photo.last?
    InteractionShowStripshow.ensure_still_valid(strip_photo.user, viewer) if strip_photo.last?
    true
  end

end
