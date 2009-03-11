# == Schema Information
# Schema version: 174
#
# Table name: external_profile_photos
#
#  id               :integer(11)   not null, primary key
#  parent_id        :integer(11)   
#  content_type     :string(255)   
#  filename         :string(255)   
#  thumbnail        :string(255)   
#  size             :integer(11)   
#  width            :integer(11)   
#  height           :integer(11)   
#  yahoo_profile_id :integer(11)   
#

class ExternalProfilePhoto < ActiveRecord::Base
  belongs_to :yahoo_profile
  has_attachment :content_type => :image, 
                 :storage => :s3, 
                 :max_size => 500.kilobytes,
                 :resize_to => '320x200>',
                 :thumbnails => {
                   :thumb => "80x80!"
                 }

  validates_as_attachment

end
