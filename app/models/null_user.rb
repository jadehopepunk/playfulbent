
class NullUser
  
  def strip_shows
    []
  end
  
  def has_stripshow
    false
  end
  
  def has_interest?(interest)
    false
  end
  
  def has_kink?(interest)
    false
  end
  
  def id
    0
  end
  
  def is_admin
    false
  end
  
  def new_record?
    true
  end
  
  def interaction_score_with(other_user)
    0
  end
  
  def nick
    'unknown'
  end
  
  def name
    'Unknown'
  end
  
  def profile_url
    "http://#{ActionController::UrlWriter.default_url_options[:host]}"
  end
  
  def avatar_thumb_image_url
    Avatar.blank_image_url
  end
  
  def can_access_sponsor_features?
    false
  end
  
  def html_avatar
    html_image_options = {}
    html_image_options[:size] = '80x80'
    html_image_options[:alt] = nick
    avatar_image = "<img src=\"#{avatar_thumb_image_url}\" alt=\"#{nick}\" style=\"border: 1px solid #000; display: block; margin: 10px 10px 0 10px;\" width=\"80\" height=\"80\" />"
    avatar_name = "<span style=\"width: 100px; display: block;\">#{name}</span>"
    user_styles = 'float: left; margin: 0 10px 10px 0; background: #927B69 url(http://www.playfulbent.com/images/forum/avatar_background.png) top left repeat; border: 3px solid #000; color: #000; text-align: center; line-height: 30px; overflow: hidden; z-index: 1;'
    "<a href=\"#{profile_url}\" style=\"#{user_styles}\">#{avatar_image}<span>#{name}</span></a>"
  end
  
  def yahoo_profiles
    []
  end
  
  def crush_on(other_user)
  end
  
  def current_dare_challenge_with(other_user)
  end
  
  def gender
    NullGender.new
  end
  
end