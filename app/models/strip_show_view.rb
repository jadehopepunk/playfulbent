# == Schema Information
# Schema version: 258
#
# Table name: strip_show_views
#
#  id                  :integer(11)   not null, primary key
#  strip_show_id       :integer(11)   
#  user_id             :integer(11)   
#  max_position_viewed :integer(11)   
#  created_at          :datetime      
#  updated_at          :datetime      
#

class StripShowView < ActiveRecord::Base
  belongs_to :strip_show
  belongs_to :user
  
  validates_presence_of :strip_show, :user, :max_position_viewed
  
  def self.update_max_position(strip_show, user, max_position)
    show_view = find_or_initialise_by_strip_show_and_user(strip_show, user)
    if show_view && (show_view.max_position_viewed.nil? || max_position > show_view.max_position_viewed)
      show_view.max_position_viewed = max_position
      show_view.save!
    end
  end
  
  def self.find_or_initialise_by_strip_show_and_user(strip_show, user)
    return nil unless strip_show and user
    find_by_strip_show_and_user(strip_show, user) || StripShowView.new(:strip_show => strip_show, :user => user)
  end
  
  def self.find_by_strip_show_and_user(strip_show, user)
    find(:first, :conditions => {:strip_show_id => strip_show.id, :user_id => user.id}) if strip_show && user
  end
    
end
