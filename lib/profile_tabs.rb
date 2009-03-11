module ProfileTabs
  
  def load_profile_tabs(active_tab)
    @tab_details = []
    @tab_details << [:profiles, 'About Me', @user.profile_url]
    
    @tab_details << [:relationships, 'My Friends', user_relationships_url(@user)]

    if current_user == @user || @user.has_gallery_photos?
      @tab_details << [:photo_sets, 'My Pictures', user_photo_set_url(@user, @user.default_photo_set)]
    end

    if current_user == @user || @user.has_blog?
      @tab_details << [:my_blogs, 'My Blog', user_my_blogs_url(@user) ]
    end
    
    @tab_details << [:my_stripshows, 'My Strip-Shows', user_my_stripshows_url(@user)]
    @tab_details << [:my_stories, 'My Stories', user_my_stories_url(@user)]
    @tab_details << [:my_dares, 'My Dares', user_my_dares_url(@user)]

    if current_user == @user
      @tab_details << [:messages, 'My Messages', user_messages_url(@user) ]
    else
      @tab_details << [:messages, 'My Messages', user_message_interactions_url(@user) ]
    end

    @tab_details << [:settings, 'My Settings', user_settings_url(@user)] if current_user == @user

    @active_tab = active_tab
  end
  
end