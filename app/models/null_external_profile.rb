
class NullExternalProfile
  
  def name
    'unknown'
  end
  
  def profile_url
    ''
  end
  
  def can_access_sponsor_features?
    false
  end
  
  def image_thumb_url
    Avatar.blank_image_url
  end
  
  def avatar_thumb_image_url
    Avatar.blank_image_url
  end
    
end
