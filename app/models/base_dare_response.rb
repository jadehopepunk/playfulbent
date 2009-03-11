# == Schema Information
# Schema version: 258
#
# Table name: base_dare_responses
#
#  id                :integer(11)   not null, primary key
#  user_id           :integer(11)   
#  dare_id           :integer(11)   
#  created_on        :datetime      
#  description       :text          
#  photo             :string(255)   
#  type              :string(255)   
#  dare_challenge_id :integer(11)   
#

class BaseDareResponse < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :photo, :if => :dare_requires_photo
  validates_presence_of :description, :if => :dare_requires_description
  validate :check_user_isnt_darer
  validate :requires_some_info

  file_column :photo, :magick => 
    {
      :size => "600>x1000>", 
      :versions => { 
        :thumb => {
          :size => "80x80!", 
          :crop => "1:1"
        }
      }
    }, 
    :store_dir => RAILS_ROOT + "/public/system/dare_response/photo", 
    :base_url => "images/system/dare_response/photo/"

  def self.collection_to_rss(title, articles, base_url)
    rss = RSS::Rss.new( "2.0" )
    channel = RSS::Rss::Channel.new
    channel.title = title
    channel.link = base_url + "/dares"

    for article in articles
      channel.items << article.to_rss(base_url)
    end
    rss.channel = channel

    return rss.to_s    
  end  

  def to_rss(base_url)
    item = RSS::Rss::Channel::Item.new
    item.link = base_url + '/dares/' + dare.to_param
    item.pubDate = created_on
    item.description = html_avatar + html_content
    item.title = dare.request
    item
  end

protected

  def html_content
    result = ''
		result << description
    result << photo_tag
		result
  end

  def thumb_photo_tag
    "<img src=\"#{thumb_photo_url}\" alt=\"dare response\" style=\"border: 1px solid #000; display: block; margin: 10px;\" width=\"80\" height=\"80\" />"
  end

  def photo_tag
    "<img src=\"#{photo_url}\" alt=\"dare response\" style=\"border: 1px solid #000; display: block; margin: 10px; clear: both;\" />"
  end

  def thumb_photo_url
    photo_options[:base_url] + photo_relative_path('thumb') if photo
  end  

  def photo_url
    photo_options[:base_url] + photo_relative_path if photo
  end  

  def html_avatar
    user ? user.html_avatar + ' ': ''
  end
  
  def darer
    nil
  end

  def check_user_isnt_darer
    if darer
      errors.add_to_base "You can't complete your own dare!" if user == darer
    end
  end

  def requires_some_info
    unless dare_requires_photo || dare_requires_description
      if description.blank? && !photo
        errors.add_to_base "You must supply either a photo or a description"
      end 
    end
  end

end
