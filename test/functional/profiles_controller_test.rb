require File.dirname(__FILE__) + '/../test_helper'
require 'profiles_controller'
require 'profile'

# Re-raise errors caught by the controller.
class ProfilesController; def rescue_action(e) raise e end; end

class ProfilesControllerTest < Test::Unit::TestCase
  fixtures :profiles, :users, :email_addresses, :interests, :kinks, :tags, :taggings, :locations, :photo_sets, :gallery_photos
  
  def setup
    @controller = ProfilesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def setup_mocks
    @bilbo = User.new(:nick => 'bilbo', :created_on => Time.now)
    @bilbo.stubs(:to_param).returns(12)
    @bilbo.stubs(:id).returns(12)
    @bilbo.stubs(:new_record?).returns(false)
    
    @frodo = User.new(:nick => 'frodo', :created_on => Time.now)
    @frodo.stubs(:new_record?).returns(false)
    
    @bilbo_profile = Profile.new(:user => @bilbo)
    @bilbo_profile.stubs(:id).returns(23)
    @bilbo_profile.stubs(:to_param).returns('bilbo')
    @bilbo_profile.stubs(:interest_tag_string).returns('')
    @bilbo_profile.stubs(:kink_tag_string).returns('')
    @bilbo_profile.stubs(:default_photo_set).returns(photo_sets(:sams_photos))
    @bilbo.stubs(:profile).returns(@bilbo_profile)
    
    @frodo_profile = Profile.new(:user => @frodo)
    @frodo_profile.stubs(:id).returns(1)
    @frodo_profile.stubs(:to_param).returns(1)
    @frodo_profile.stubs(:kinks).returns(Kinks.new)
    @frodo_profile.stubs(:interests).returns(Interests.new)
    
    @frodo.stubs(:profile).returns(@frodo_profile)
    
    @image1 = create_image_stub('fish1.png')
    @image2 = create_image_stub('fish2.png')
    @image3 = create_image_stub('fish3.png')
    @image4 = create_image_stub('fish4.png')
    @image5 = create_image_stub('fish5.png')
    @five_images = [@image1, @image2, @image3, @image4, @image5]
    
    @find_params = {:order => 'profiles.created_on DESC', :conditions => ['(profiles.published = 1 AND profiles.disabled != 1 AND users.nick IS NOT NULL) AND (avatars.id IS NOT NULL)'], :offset => 0, :include => [:avatar, {:interests => :tags}, {:kinks => :tags}, {:user => :sponsorship}], :limit => 10}
    
    Profile.stubs(:find).with('23').returns(@bilbo_profile)
    Profile.stubs(:find_by_param).with('bilbo').returns(@bilbo_profile)
  end
  
  def tag(name)
    Tag.new(:name => name)
  end
  
  def create_image_stub(path)
    photo = LocalGalleryPhoto.new
    photo.stubs(:to_param).returns('1')
    photo.stubs(:photo_set).returns(photo_sets(:sams_photos))
    photo
  end
  
  def no_tags
    @bilbo_profile.stubs(:interest_tags).returns([])
    @bilbo_profile.stubs(:kink_tags).returns([])
  end
  
  def test_that_index_doesnt_include_disabled_profiles
    get :index
    assert !assigns(:profiles).map(&:user).map(&:nick).include?('merri')
  end
  
  #---------------------------------------------------------------
  # SHOW
  #---------------------------------------------------------------
  
  def test_displays_no_empty_gallery_images    
    setup_mocks
    no_tags
    login_as_mock @frodo
    get :show, {'id' => "bilbo"}
    assert_no_tag :tag => 'img', :ancestor => {:attributes => {:class => 'gallery'}}
  end

  def test_displays_empty_gallery_images_for_your_profile
    setup_mocks
    no_tags
    login_as_mock @bilbo
    get :show, {'id' => "bilbo"}
    assert_tag :tag => 'img', :parent => {:tag => 'a', :ancestor => {:attributes => {:class => 'gallery'}}}
  end
  
  def test_displays_interests
    setup_mocks
    @bilbo_profile.stubs(:interest_tags).returns([tag('cat'), tag('boot')])
    @bilbo_profile.stubs(:kink_tags).returns([])

    login_as_mock @frodo
    get :show, {'id' => "bilbo"}
    assert_tag :tag => 'span', :attributes => {:class => 'tag'}, :content => 'cat'
    assert_tag :tag => 'span', :attributes => {:class => 'tag'}, :content => 'boot'
  end
  
  def test_highlights_viewers_interests
    setup_mocks
    @bilbo_profile.stubs(:interest_tags).returns([tag('cat'), tag('boot')])
    @frodo.stubs(:has_interest?).with(tag('cat')).returns(true)
    @frodo.stubs(:has_interest?).with(tag('boot')).returns(false)
    @bilbo_profile.stubs(:kink_tags).returns([])

    login_as_mock @frodo
    get :show, {'id' => "bilbo"}
    assert_tag :tag => 'span', :attributes => {:class => 'tag shared_tag'}, :content => 'cat'
    assert_tag :tag => 'span', :attributes => {:class => 'tag'}, :content => 'boot'
  end
  
  def test_own_profile_doesnt_highlight_interests
    setup_mocks
    @bilbo_profile.stubs(:interest_tags).returns([tag('cat'), tag('boot')])
    @bilbo.stubs(:has_interest?).with(tag('cat')).returns(true)
    @bilbo.stubs(:has_interest?).with(tag('boot')).returns(false)
    @bilbo_profile.stubs(:kink_tags).returns([])

    login_as_mock @bilbo
    get :show, {'id' => "bilbo"}
    assert_tag :tag => 'span', :attributes => {:class => 'tag'}, :content => 'cat'
    assert_tag :tag => 'span', :attributes => {:class => 'tag'}, :content => 'boot'
  end
  
  def test_displays_kinks
    setup_mocks
    @bilbo_profile.stubs(:kink_tags).returns([tag('moose'), tag('pumpkin')])
    @bilbo_profile.stubs(:interest_tags).returns([])

    login_as_mock @frodo
    get :show, {'id' => "bilbo"}
    assert_tag :tag => 'span', :attributes => {:class => 'tag'}, :content => 'moose'
    assert_tag :tag => 'span', :attributes => {:class => 'tag'}, :content => 'pumpkin'
  end
  
  def test_highlights_viewers_kinks
    setup_mocks
    @bilbo_profile.stubs(:kink_tags).returns(['moose', 'pumpkin'])
    @frodo.stubs(:has_kink?).with('moose').returns(true)
    @frodo.stubs(:has_kink?).with('pumpkin').returns(false)
    @bilbo_profile.stubs(:interest_tags).returns([])

    login_as_mock @frodo
    get :show, {'id' => "bilbo"}
    assert_tag :tag => 'span', :attributes => {:class => 'tag shared_tag'}, :content => 'moose'
    assert_tag :tag => 'span', :attributes => {:class => 'tag'}, :content => 'pumpkin'
  end
  
  def test_own_profile_doesnt_highlight_kinks
    setup_mocks
    @bilbo_profile.stubs(:kink_tags).returns(['moose', 'pumpkin'])
    @bilbo.stubs(:has_kink?).with('moose').returns(true)
    @bilbo.stubs(:has_kink?).with('pumpkin').returns(false)
    @bilbo_profile.stubs(:interest_tags).returns([])

    login_as_mock @bilbo
    get :show, {'id' => "bilbo"}
    assert_tag :tag => 'span', :attributes => {:class => 'tag'}, :content => 'moose'
    assert_tag :tag => 'span', :attributes => {:class => 'tag'}, :content => 'pumpkin'
  end

  def test_that_show_displays_show_template
    login_as :bob
    get :show, {:id => 'sam'}
    assert_response :success
    assert_template 'show'
  end
  
  def test_that_show_displays_disabled_template_if_profile_is_disabled
    login_as :bob
    get :show, {:id => 'merri'}
    assert_response :success
    assert_template '_show_disabled'
  end
  
  def test_that_show_assigns_location_if_own_profile
    login_as :sam
    get :show, :id => 'sam'
    
    assert assigns(:location)
    assert_equal locations(:melbourne), assigns(:location)
  end
  
  #---------------------------------------------------------------
  # DISABLE
  #---------------------------------------------------------------
  
  def test_that_disable_requires_login
    assert_requires_login do |proxy|
      proxy.put :disable, :id => 'sam'
    end
  end
  
  def test_that_disable_requires_profile_to_be_editable_by_current_user
    assert_requires_access(:bob) do |proxy|
      proxy.put :disable, :id => 'sam'
    end
  end
  
  def test_that_disable_disables_profile_and_redirects_to_index
    login_as :sam
    put :disable, :id => 'sam'
    
    assert users(:sam).reload.disabled?
    assert_redirected_to users(:sam).profile_url
  end
  
  #---------------------------------------------------------------
  # ENABLE
  #---------------------------------------------------------------
  
  def test_that_enable_requires_login
    assert_requires_login do |proxy|
      proxy.put :enable, :id => 'merri'
    end
  end

  def test_that_enable_requires_profile_to_be_editable_by_current_user
    assert_requires_access(:bob) do |proxy|
      proxy.put :enable, :id => 'merri'
    end
  end
  
  def test_that_enable_enables_profile_and_redirects_to_index
    login_as :disabled
    put :enable, :id => users(:disabled).permalink

    assert !users(:disabled).reload.disabled?
    assert_redirected_to users(:disabled).profile_url
  end

  #---------------------------------------------------------------
  # UPDATE INTERESTS
  #---------------------------------------------------------------

  def test_that_update_interests_requires_login
    assert_requires_login do |proxy|
      proxy.put :update_interests, :id => profiles(:sam).to_param
    end
  end
  
  def test_that_update_interests_requires_profile_to_be_editable_by_current_user
    assert_requires_access(:frodo) do |proxy|
      proxy.put :update_interests, :id => profiles(:sam).to_param
    end
  end
  
  def test_that_update_interests_sets_interest_tags_on_profile
    login_as :sam
    put :update_interests, :id => profiles(:sam).to_param, 'profile'=> {'interest_tag_string' => 'cooking, reading, fishing'}
    
    profile = profiles(:sam).reload
    assert_equal 'cooking, reading, fishing', profile.interest_tag_string.to_s
  end
  
  #---------------------------------------------------------------
  # UPDATE KINKS
  #---------------------------------------------------------------

  def test_that_update_kinks_requires_login
    assert_requires_login do |proxy|
      proxy.put :update_kinks, :id => profiles(:sam).to_param
    end
  end
  
  def test_that_update_kinks_requires_profile_to_be_editable_by_current_user
    assert_requires_access(:frodo) do |proxy|
      proxy.put :update_kinks, :id => profiles(:sam).to_param
    end
  end

  def test_that_update_kinks_sets_kink_tags_on_profile
    login_as :sam
    put :update_kinks, :id => profiles(:sam).to_param, 'profile'=> {'kink_tag_string' => 'sex, drugs, rock and roll'}
    
    profile = profiles(:sam).reload
    assert_equal 'sex, drugs, rock and roll', profile.kink_tag_string.to_s
  end
  
end
