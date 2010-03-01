# == Schema Information
#
# Table name: flickr_accounts
#
#  id         :integer(4)      not null, primary key
#  nsid       :string(255)
#  token      :string(255)
#  username   :string(255)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class FlickrAccount < ActiveRecord::Base
  belongs_to :user
  
  def self.create_from_frob(frob, user)
    FlickrAccount.create(:user => user, :frob => frob)
  end
  
  def frob=(value)
    self.token_data = fetch_token(value)
  end
  
  def token_data=(value)
    self.token = value.token
    self.nsid = value.user.nsid
    self.username = value.user.username
  end
  
  def flickr_photo_sets
    @photo_sets || @photo_sets = flickr.photosets.getList(nsid)
  end
  
  def owns_photo_set?(photo_set_id)
    !!external_photo_set(photo_set_id)
  end
  
  def external_photo_set(photo_set_id)
    for set in flickr_photo_sets
      return set if set.id == photo_set_id
    end
    nil
  end
  
  def flickr
    @flickr || load_flickr
  end
  
  protected
  
    def fetch_token(frob)
      flickr.auth.getToken(frob)
    end
  
    def load_flickr
      @flickr = Flickr.new(nil, AppConfig.flickr_api_key, AppConfig.flickr_shared_secret)
      @flickr.auth.token = flickr_token
      @flickr
    end
    
    def flickr_token
      Flickr::Token.new(token, 'read', flickr_person)
    end
    
    def flickr_person
      Flickr::Person.new(@flickr, nsid, username)
    end
  
  
end
