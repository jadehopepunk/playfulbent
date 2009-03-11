module PagesHelper
  
  def read_on_text(version)
    if version.being_followed_by(current_user)
      image_tag("buttons/read_on.png", :alt => 'Read On')
    else
      image_tag("buttons/follow_this_version.png", :alt => 'Follow This Version')
    end
  end
  
end
