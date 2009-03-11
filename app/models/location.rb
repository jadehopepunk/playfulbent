# == Schema Information
# Schema version: 258
#
# Table name: locations
#
#  id         :integer(11)   not null, primary key
#  country    :string(255)   
#  city       :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#

class Location < ActiveRecord::Base
  validates_length_of :country, :city, :maximum => 255, :allow_nil => true
  
  def name
    parts = []
    parts << city unless city.blank?
    parts << country unless country.blank?
    parts.join(', ')
  end
  
  def contains_no_data?
    country.blank? && city.blank?
  end
  
end
