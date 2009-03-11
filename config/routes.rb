ActionController::Routing::Routes.draw do |map|

  # not using profile subdomains
  #map.connect '', :controller => 'home', :action => 'index'
  
  # profile subdomains
  map.connect '', :controller => 'home', :action => 'index', :conditions => {:subdomain => /^(www|)$/}
  map.connect '', :controller => 'profiles', :action => 'show'
  map.connect 'index.:format', :controller => 'home', :action => 'index'

  map.resources :performance_reports, :tags, :dare_responses, :pages, :external_profile_photos, :dare_rejections
  map.resources :crushes
  map.resource :session
  
  map.resources :products do |products|
    products.resources :urls, :controller => 'ProductUrls'
  end
  map.resources :reviews do |reviews|
    reviews.resources :action_shots
  end

  map.resources :groups do |groups|
    groups.resources :mailing_list_messages
    groups.resources :group_members
  end
  map.resources :yahoo_profiles, :member => {:claim => :post}
  map.resources :home, :collection => { :new_index => :get, :about_interactions => :get, :credits => :get }
  
  map.resources :profiles, :member => { :update_welcome_text => :post, :update_interests => :post, :update_kinks => :post, :disable => :put, :enable => :put } do |profiles|
    profiles.resource :avatar
    profiles.resource :user_location
  end  
  
  map.resources :dares, :collection => { :about => :get }
  
  map.resources :stories do |stories|
    stories.resources :story_subscriptions, :member => {:update => :post}
    stories.resources :parent do |parent|
      parent.resources :pages, :member => {:stop_following => :post}, :name_prefix => 'child_'
    end  
  end

  map.resources :notification_requests, :dare_response_photos, :blogs
  map.resources :conversations do |conversations|
    conversations.resources :comments
  end
  
  map.resources :users, :member => {:update_password => :put, :update_gender_and_sexuality => :put} do |users|
    users.resources :sponsorships, :collection => {:submitted => :get, :notify => :post}
    users.resources :my_stories
    users.resources :my_dares
    users.resources :my_stripshows
    users.resources :relationships, :collection => {:reorder => :post}
    users.resources :settings, :member => {:set_user_email => :post}
    users.resources :messages, :member => {:read => :post}, :collection => {:sent => :get}
    users.resources :message_interactions
    users.resources :my_blogs
    users.resources :photo_sets, :member => {:check_importing => :get} do |photo_sets|
      photo_sets.resources :my_photos, :member => {:update_meta => :put}, :collection => {:reorder => :post}
    end
  end
  map.resources :photo_sets do |photo_sets|
    photo_sets.resources :photos do |photos|
      photos.resources :files, :controller => 'GalleryPhotoFiles'
    end
  end
  map.resources :photos
  map.resource :flickr_authorisation, :collection => {:check => :get}
  
  map.resources :strip_photos, :member => {:show_thumb => :get, :next => :get}

  map.resources :dare_challenges, :member => {:reject => :delete}, :collection => {:possible_subjects => :get} do |dare_challenges|
    dare_challenges.resources :dare_challenge_responses
  end
  
  map.resources :events
  map.resources :activities
  map.resources :emails, :member => {:verify => :get, :update_verified => :put, :verify_new_user => :post}
  map.resources :fantasies
  map.resources :fantasy_roles
  map.resources :fantasy_actors
  
  # Install the default route as the lowest priority.
  map.connect 'invitations/:action/:id/:user_id', :controller => 'invitations'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.png'  
  
end
