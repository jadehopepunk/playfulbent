module Additional
  module UserLinkHelper

    def link_to_profile_for(user, name = nil, class_name = 'user_link')
      user = NullUser.new if user.nil?
      
      name = user.name if name.nil?
			link_to h(name), user.profile_url, :class => class_name
    end
  
    def mini_avatar_link_for(user, html_image_options = {})
      user = NullUser.new if user.nil?
      
      html_image_options[:class] = html_image_options[:class].blank? ? "mini_avatar" : html_image_options[:class] + ' mini_avatar' 
      html_image_options[:size] = '20x20'
      html_image_options[:alt] = user.name
      html_image_options[:title] = user.name
      avatar_image = image_tag(user.avatar_thumb_image_url, html_image_options)
      link_to(avatar_image, user.profile_url, :class => 'mini_avatar_pointer') + image_tag('arrow.png', :alt => '', :class => 'mini_avatar_pointer')
    end
      
    def mini_avatar_link_for_external_profile(user, html_image_options = {})
      user = NullExternalProfile.new if user.nil?

      html_image_options[:class] = html_image_options[:class].blank? ? "mini_avatar" : html_image_options[:class] + ' mini_avatar' 
      html_image_options[:size] = '20x20'
      html_image_options[:alt] = user.name
      html_image_options[:title] = user.name
      avatar_image = image_tag(user.avatar_thumb_image_url, html_image_options)
      link_to(avatar_image, user.profile_url, :class => 'mini_avatar_pointer')
    end

    def avatar_link_for(user, link_options = {})
      user = NullUser.new if user.nil?
      
      html_image_options = {}
      html_image_options[:size] = '80x80'
      html_image_options[:alt] = user.name
      html_image_options[:title] = user.name
      html_image_options[:class] = 'avatar_image'

      avatar_image = ''
      if user.can_access_sponsor_features?
        avatar_image = image_tag('profiles/halo.png', :alt => 'playful bent sponsor', :class => 'avatar_halo', :title => "#{user.name} helps sponsor this site")
      end
      avatar_image += image_tag(user.avatar_thumb_image_url, html_image_options)
      avatar_image = content_tag('span', avatar_image, :class => 'avatar_image_collection')
      
      link_options[:class] = link_options[:class].blank? ? "avatar_link" : link_options[:class] + ' avatar_link'
          
      link_to(avatar_image, user.profile_url, link_options) 
    end
    
    def avatar_link_for_external_profile(external_profile, link_options = {})
      external_profile = NullExternalProfile.new if external_profile.nil?
      avatar_link_for(external_profile, link_options)
    end
    
    def avatar_and_name_link_for_external_profile(external_profile, html_image_options = {})
      external_profile = NullExternalProfile.new if external_profile.nil?
      link_to(avatar_and_name_for_external_profile(external_profile, html_image_options), external_profile.url, :class => 'avatar_link avatar_link_with_name')
    end

    def avatar_and_name_link_for(user, html_image_options = {})
      user = NullUser.new if user.nil?
      link_to(avatar_and_name(user, html_image_options), user.profile_url, :class => 'avatar_link avatar_link_with_name')
    end

    def avatar_and_name(user, html_image_options = {})
      user = NullUser.new if user.nil?
      
      html_image_options[:class] = html_image_options[:class].blank? ? "avatar_image" : html_image_options[:class] + ' avatar_image' 
      html_image_options[:size] = '80x80'
      html_image_options[:alt] = user.nick

      avatar_image = image_tag(user.avatar_thumb_image_url, html_image_options)
    
      name_string = ''
      if user.can_access_sponsor_features?
        name_string = image_tag('profiles/halo.png', :alt => 'playful bent sponsor', :class => 'avatar_halo avatar_and_name_halo', :title => "#{user.name} helps sponsor this site")
      end
      name_string += user.name

      avatar_image + content_tag('span', name_string, :class => 'user_name')
    end

    def interaction_ticks_for(user)
      ticks = []
      interaction_score = current_user.interaction_score_with(user)
      return "" if interaction_score == 0

      for count in 1..interaction_score
        ticks << image_tag('profiles/tick.png', :alt => 'Each tick represents one type of interaction with this person', :class => 'interaction_tick')
      end
      all_ticks = ticks.join(' ')
      title = "You have interacted with this person in #{interaction_score} different way#{'s' unless interaction_score == 1}"
      content_tag 'span', all_ticks, :class => 'interaction_tick_list', :title => title
    end

    def interaction_ticks_for_external_profile(external_profile)
      external_profile && external_profile.user ? interaction_ticks_for(external_profile.user) : ''
    end
    
    def tags_with_bold_shared(profile, tag_type, current_user, tag_limit)
      tag_method = "#{tag_type}_tags".to_sym
      has_tag_method = "has_#{tag_type}?".to_sym
      tags = profile.send(tag_method).slice(0, 25)
      
      tag_spans = tags.collect do |tag| 
        current_user_has_tag = (current_user && current_user.send(has_tag_method, tag) && current_user != profile.user)
        tag_classes = ['tag']
        tag_classes << 'shared_tag' if current_user_has_tag

        content_tag('span', tag.to_s, :class => tag_classes.join(' '))
      end
      
      tag_spans.join(", ")
    end
    
    def external_profile_tags_with_bold_shared(external_profile, tag_type, current_user, tag_limit)
      tags_with_bold_shared(external_profile, tag_type, current_user, tag_limit)
    end
    
    def user_timestamp(user)
      if user.last_logged_in_at
        if user.last_logged_in_at > 11.minutes.ago
          message = "currently online"
        else
          message = "#{time_ago_in_words(user.last_logged_in_at)} ago"
        end
        content_tag('div', message, :class => 'last_logged_in')
      end
    end

  end
end