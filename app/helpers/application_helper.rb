
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include Additional::UserLinkHelper
  include Additional::InPlaceFormHelper
  include Additional::FormHelper
  include Additional::TagHelper
  include Additional::StringHelper
  include Additional::TabSystemHelper  
  include Additional::UrlHelper  
  include Additional::ActivitiesHelper
  include Additional::PermissionsHelper

  def spinner(name, text = nil)
    spinner_image = image_tag("spinner.gif", :alt => 'loading')
    content_tag 'span', " #{text} #{spinner_image}", :style => 'display: none', :id => 'spinner_' + name.to_s, :class => 'loading'
  end 

  def show_spinner(name)
    "Element.show('spinner_#{name}');"
  end
  
  def hide_spinner(name)
    "Element.hide('spinner_#{name}');"
  end
  
  def label(name, fieldname, required = nil)
    requirement = '<span class="requirement">(optional)</span>' if required == false
    requirement = '<span class="requirement">(required)</span>' if required == true
		"<label for=\"#{fieldname}\">#{name} #{requirement}</label>"
  end
  
  def logged_in?
    !current_user.new_record?
  end

  def dom_id(record, prefix = nil) 
    prefix ||= 'new' unless record.id 
    [ prefix, singular_class_name(record), record.id ].compact * '_'
  end

  def singular_class_name(record_or_class)
    class_from_record_or_class(record_or_class).name.underscore.tr('/', '_')
  end
  
  def class_from_record_or_class(record_or_class)
    record_or_class.is_a?(Class) ? record_or_class : record_or_class.class
  end
  
  def strip_show_thumb(show, size = '80x80')
    image_tag(show.thumb_url, :alt => show.title, :title => show.title, :size => size, :class => 'strip_show_thumb') unless show.strip_photos.empty?  
  end
  
  def zero_or_id(model)
    (model.nil? ? 0 : model)
  end  
  
  def alternate_format_links
    unless @alternate_formats.nil?
      links = @alternate_formats.collect do |format|
        tag 'link', {'rel' => 'alternate'}.merge(format)
      end
      links.join("\n")
    end
  end
  
  def subscription_links
    unless @alternate_formats.nil?
      links = @alternate_formats.collect do |format|
        link_to image_tag('rss.gif', :alt => 'RSS') + ' Subscribe with RSS', format['href']
      end
      content_tag 'div', links.join(" "), :class => 'subscription_links'
    end
  end
  
  def link_to_comment_on_this(conversation, subject)
    if !logged_in?
      link_to "Log In to Comment on This", new_session_url
		elsif !conversation.nil?
			link_to_remote('Comment on This', {:url => formatted_new_conversation_comment_path(conversation, :js), :method => 'get', :loading => "Element.show('spinner_new_comment')", :complete => "Element.hide('spinner_new_comment'); Element.hide('new_comment_link'), Element.show('new_comment_container')"}, :id => 'new_comment_link')
		elsif !subject.nil?
			link_to_remote('Comment on This', {:url => formatted_new_conversation_path(:subject_id => subject.id, :subject_type => subject.class.name, :format => :js), :method => 'get', :loading => "Element.show('spinner_new_comment')", :complete => "Element.hide('spinner_new_comment'); Element.hide('new_comment_link'), Element.show('new_comment_container')"}, :id => 'new_comment_link')
		end
  end
  
  def ajax_pagination_links(paginator, identifier, options={}, html_options={})
    name = options[:name] || ActionView::Helpers::PaginationHelper::DEFAULT_OPTIONS[:name]
    url_params = (options[:params] || ActionView::Helpers::PaginationHelper::DEFAULT_OPTIONS[:params]).clone

    links = pagination_links_each(paginator, options) do |n|
      url_params[name] = n
      link_to_remote(n.to_s, {:url => url_params, :method => :get, :loading => "Element.update('#{identifier}_loading_number', #{n}); Element.hide('#{identifier}_links'); Element.show('#{identifier}_loading')", :complete => "Element.show('#{identifier}_links'); Element.hide('#{identifier}_loading')"}, html_options)
    end
    loading_number = content_tag('span', '', :id => "#{identifier}_loading_number")
    loading_spinner = image_tag 'spinner.gif'
    loading = content_tag('div', "...loading page " + loading_number + ' ' + loading_spinner, :id => "#{identifier}_loading", :style => "display:none", :class => 'loading_text')
    links_tag = content_tag('div', links, :id => "#{identifier}_links")
    links_tag + loading
  end
  
  def flash_message(details = {})
    heading = details[:heading] || ''
    text = details[:text] || ''
    type = details[:type] || ''

    heading = content_tag 'div', heading, :class => 'heading'
    content_tag 'div', heading + text, :class => "flash_#{type}"
  end

  def tumbler(count)
    count_string = count.to_s.rjust 5, '0'
    
    numbers = []
    count_string.each_char do |char|
      numbers << content_tag('span', char, :class => 'number')
    end
    content_tag 'span', numbers.join(' '), :class => 'tumbler'
  end

  def page_version_url(version)
    child_pages_url(:story_id => version.story, :parent_id => zero_or_id(version.parent))
  end
  
  def stars(count)
    star_images = (1..count).collect {|number| image_tag('star.png', :alt => "#{count} stars") }
    content_tag 'span', star_images.join(''), :class => 'stars'
  end
  
  def stars_with_label(title, count, max = 5)
    star_label = content_tag 'h3', "#{title}: #{count}/#{max}", :class => 'rating_label'
    content_tag 'div', star_label + ' ' + stars(count), :class => 'stars_with_label'
  end
  
  def photo_set_image_url(photo_set)
    photo_set.display_photo ? url_for_gallery_photo(photo_set.display_photo, 'thumb') : 'areas/photos.jpg'
  end
  
  def site_section
    if ['fantasies', 'fantasy_roles', 'fantasy_actors'].include?(controller.controller_name)
      return :fantasies
    elsif ['reviews', 'products', 'action_shots'].include?(controller.controller_name)
      return :reviews
    elsif ['photos', 'my_photos'].include?(controller.controller_name)
      return :photos
    elsif ['stripshows', 'strip_photos', 'my_stripshows'].include?(controller.controller_name)
      return :stripshows
    elsif ['dares', 'dare_responses', 'dare_challenge_responses', 'dare_rejections', 'my_dares'].include?(controller.controller_name)
      return :dares
    elsif ['stories', 'pages', 'my_stories'].include?(controller.controller_name)
      return :stories
    elsif ['blogs', 'my_blogs'].include?(controller.controller_name)
      return :blogs
    elsif ['conversations', 'comments'].include?(controller.controller_name)
      return :forum
    elsif ['profiles', 'avatar', 'crushes', 'invitations', 'massage_interactions', 'messages', 'relationships', 'settings', 'sponsorships'].include?(controller.controller_name)
      return :profiles
    end
  end

  def filter_link(title, filter_param, active)
    css_class = active ? 'active_filter' : nil
    link_to(title, params.merge(:filter => filter_param), :class => css_class)
  end

  def filter_links(possible_filters, allow_multiple = true)
    results = []
    if logged_in?
      all_filters = possible_filters.map {|filter_array| filter_array[0]}
    
      results << filter_link('All', nil, @filters.empty?) unless allow_multiple
      
      possible_filters.each do |filter_array|
        filter_sym = filter_array[0]
        filter_title = filter_array[1]
        other_filters = @filters.reject {|f| f == filter_sym }
      
        if @filters.include?(filter_sym)
          filter_param = other_filters.join(':')
        else
          filter_param = allow_multiple ? (other_filters + [filter_sym]).join(':') : filter_sym
        end
        filter_param = nil if filter_param.blank?
        results << filter_link(filter_title, filter_param, @filters.include?(filter_sym))
      end      
    end
    
    return nil if results.empty?
    prefix = allow_multiple ? "Show Only: " : "Show: "
    prefix + results.join(' | ')
  end
      
end
