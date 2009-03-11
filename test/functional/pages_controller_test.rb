require File.dirname(__FILE__) + '/../test_helper'
require 'pages_controller'

# Re-raise errors caught by the controller.
class PagesController; def rescue_action(e) raise e end; end

class PagesControllerTest < Test::Unit::TestCase
  fixtures :page_versions, :users, :email_addresses, :stories
  
  def setup
    @controller = PagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def setup_mocks
    @story = Story.new
    @story.stubs(:to_param).returns('3')
    Story.stubs(:find).with('3').returns(@story)

    @frodo = User.new(:nick => 'frodo')
    @frodo.stubs(:new_record?).returns(false)
    @frodo.stubs(:id).returns(1)

    @first_page = Page.new(nil, [])
    @bilbo = User.new(:nick => 'bilbo')
    @bilbo.stubs(:new_record?).returns(false)
    @bilbo.stubs(:id).returns(2)
    
    @authors = [@bilbo]
    @story.stubs(:first_page).returns(@first_page)
    @first_page.stubs(:authors).returns(@authors)

    @version45 = PageVersion.new(:story => @story, :author => @bilbo, :text => "eat my shorts")
    @version45.stubs(:id).returns(45)
    @version45.stubs(:to_param).returns('45')
    @version45.stubs(:follow)
    @versions = [@version45]
    @first_page.stubs(:versions).returns(@versions)
    @first_page.stubs(:first_added_version).returns(@version45)
    @first_page.stubs(:can_have_alternative?).returns(false)
    @story.page_versions.stubs(:find).with('45').returns(@version45)

    @second_page = Page.new(nil, [])
    @second_page.stubs(:can_have_alternative?).returns(true)
    @version45.stubs(:page).returns(@second_page)
  end

  def load_one_child(stub_follow = true)     
    @version20 = PageVersion.new(:story => @story, :author => @bilbo, :text => "banana cake")
    @version20.stubs(:id).returns(20)
    @version20.stubs(:to_param).returns('20')
    @version20.stubs(:new_record?).returns(false)
    @version20.stubs(:follow) if stub_follow
    @version20.stubs(:has_children?).returns(true)
    @second_page_versions = [@version20]
    @second_page.stubs(:versions).returns(@second_page_versions)
    @second_page.stubs(:parent).returns(@version45)
    @second_page.stubs(:first_added_version).returns(@version20)
    @story.page_versions.stubs(:find).with('45').returns(@version45)

    @story.page_versions.stubs(:find).with('20').returns(@version20)
  end
  
  def load_second_child
    @version21 = PageVersion.new(:story => @story, :author => @bilbo, :text => "fish breath")
    @version21.stubs(:id).returns(21)
    @version21.stubs(:follow)
    @version21.stubs(:has_children?).returns(false)
    @second_page_versions << @version21
    @story.page_versions.stubs(:find).with('21').returns(@version21)
  end
  
  #---------------------------------------------------------------
  # INDEX
  #---------------------------------------------------------------

  def test_index_displays_first_page
    setup_mocks
    @first_page.stubs(:followers).returns([])
    get :index, {:story_id => '3', :parent_id => '0'}
    assert_tag :attributes => {:id => 'page_version_45'}
  end

  def test_index_does_not_have_write_alternative_version_link
    setup_mocks
    @first_page.stubs(:followers).returns([])
    get :index, {:story_id => '3', :parent_id => '0'}
    assert_no_tag :tag => 'a', :attributes => {:class => 'image_button write_alternative'}
  end
  
  def test_index_displays_version_for_parent_page
    setup_mocks
    load_one_child
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_tag :attributes => {:id => 'page_version_20'}
    assert_no_tag :attributes => {:id => 'page_version_45'}
  end
  
  def test_index_has_write_alternative_version_link
    setup_mocks
    load_one_child
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_tag :tag => 'a', :attributes => {:class => 'image_button write_alternative'}
  end
  
  def test_version_has_only_class_if_only_version
    setup_mocks
    login_as_mock @frodo
    load_one_child
    @version20.stubs(:being_followed_by).with(@frodo).returns(false)
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_tag :attributes => {:id => 'page_version_20', :class => 'version only_version'}
  end

  def test_version_has_following_class_if_being_followed
    setup_mocks
    login_as_mock @frodo
    load_one_child
    load_second_child
    @version20.stubs(:being_followed_by).with(@frodo).returns(true)
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_tag :attributes => {:id => 'page_version_20', :class => 'version following'}
  end
  
  def test_link_says_read_on_if_already_following
    setup_mocks
    login_as_mock @frodo
    load_one_child
    load_second_child
    @version20.stubs(:being_followed_by).with(@frodo).returns(true)
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_select "a#read_page_version_20 > img[alt='Read On']"
  end
  
  def test_link_says_follow_this_version_if_not_following
    setup_mocks
    login_as_mock @frodo
    load_one_child
    load_second_child
    @version20.stubs(:being_followed_by).with(@frodo).returns(false)
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_select "a#read_page_version_20 > img[alt='Follow This Version']"
  end
  
  def test_doesnt_show_explanation_if_there_is_one_version
    setup_mocks
    load_one_child
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_no_tag :attributes => {:class => 'explanation'}, :parent => {:attributes => {:class => 'page'}}
  end

  def test_indexs_explanation_if_there_are_two_versions
    setup_mocks
    login_as_mock @frodo
    load_one_child
    load_second_child
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_tag :attributes => {:class => 'explanation'}, :parent => {:attributes => {:class => 'page'}}
    assert_tag :attributes => {:id => 'num_versions'}, :content => '2'
  end
  
  def test_index_doesnt_show_explanation_if_any_versions_are_being_followed
    setup_mocks
    login_as_mock @frodo
    load_one_child
    load_second_child
    @second_page.stubs(:being_followed_by).with(@frodo).returns(true)
    
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_no_tag :attributes => {:class => 'explanation'}, :parent => {:attributes => {:class => 'page'}}
  end
  
  def test_readers_displays_empty_text_if_no_readers
    setup_mocks
    @first_page.stubs(:followers).returns([])
    get :index, {:story_id => '3', :parent_id => '0'}
    assert_tag :attributes => {:class => 'empty_text'}, :parent => {:attributes => {:class => 'readers'}}
  end

  def test_readers_doesnt_display_empty_text_if_there_are_readers
    setup_mocks
    @first_page.stubs(:followers).returns([User.new])
    get :index, {:story_id => '3', :parent_id => '0'}
    assert_no_tag :attributes => {:class => 'empty_text'}, :parent => {:attributes => {:class => 'readers'}}
  end
  
  def test_login_reminder_displays_if_not_logged_in
    setup_mocks
    @first_page.stubs(:followers).returns([])
    get :index, {:story_id => '3', :parent_id => '0'}
    assert_tag :attributes => {:class => 'login_reminder'}
  end

  def test_login_reminder_doesnt_display_if_logged_in
    setup_mocks
    login_as_mock @frodo
    @first_page.stubs(:followers).returns([])
    get :index, {:story_id => '3', :parent_id => '0'}
    assert_no_tag :attributes => {:class => 'login_reminder'}
  end
  
  def test_index_doesnt_mark_page_as_read_if_not_logged_in
    setup_mocks
    load_one_child(false)
    @version20.expects(:follow).never
    
    get :index, {:story_id => '3', :parent_id => '20'}
  end
  
  def test_index_marks_page_as_read_if_logged_in
    setup_mocks
    login_as_mock @frodo
    load_one_child(false)
    @version20.expects(:follow).with(@frodo)
    
    get :index, {:story_id => '3', :parent_id => '20'}
  end
  
  def test_read_on_link_doesnt_display_if_there_is_no_next_page
    setup_mocks
    login_as_mock @frodo
    load_one_child
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_no_tag :attributes => {:id => 'read_page_version_21'}
  end
  
  def test_stop_following_link_shows_if_can_stop_following
    setup_mocks
    login_as_mock @frodo
    load_one_child
    @version20.stubs(:can_stop_following).with(@frodo).returns(true)

    get :index, {:story_id => '3', :parent_id => '45'}
    assert_tag :attributes => {:id => 'stop_following_page_version_20'}
  end
  
  def test_stop_following_link_doesnt_show_if_cant_stop_following
    setup_mocks
    login_as_mock @frodo
    load_one_child
    @version20.stubs(:can_stop_following).with(@frodo).returns(false)

    get :index, {:story_id => '3', :parent_id => '45'}
    assert_no_tag :attributes => {:id => 'stop_following_page_version_20'}
  end
  
  def test_edit_link_displays_if_viewing_user_is_author
    setup_mocks
    login_as_mock @bilbo
    load_one_child
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_tag :tag => 'a', :attributes => {:id => 'edit_page_version_20'}
  end
  
  def test_edit_link_doesnt_display_if_viewing_user_is_not_author
    setup_mocks
    login_as_mock @frodo
    load_one_child
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_no_tag :tag => 'a', :attributes => {:id => 'edit_page_version_20'}
  end
  
  def test_mail_settings_display_if_logged_in
    setup_mocks
    login_as_mock @frodo
    load_one_child
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_tag :tag => 'div', :attributes => {:id => 'mail_settings'}
  end
  
  def test_mail_settings_dont_display_if_not_logged_in
    setup_mocks
    load_one_child
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_no_tag :tag => 'div', :attributes => {:id => 'mail_settings'}
  end
  
  def test_continue_page_i_wrote_defaults_to_true
    setup_mocks
    login_as_mock @frodo
    load_one_child
    get :index, {:story_id => '3', :parent_id => '45'}
    assert_tag :tag => 'input', :attributes => {:type => 'checkbox', :id => 'story_subscription_continue_page_i_wrote', :checked => 'checked'}
  end
  
  def test_that_no_continue_link_displays_if_this_is_an_end_page
    setup_mocks
    login_as_mock @frodo
    load_one_child
    @version45.is_end = true
    get :index, {:story_id => '3', :parent_id => '0'}
    assert_no_tag :tag => 'a', :attributes => {:id => 'continue_page_version_45'}
  end
  
  def test_index_informs_page_that_it_has_been_viewed
    setup_mocks
    login_as_mock @frodo
    load_one_child
    @second_page.expects(:on_viewed).with(@frodo)
    
    get :index, {:story_id => '3', :parent_id => '45'}
  end
  
  def test_index_doesnt_inform_page_that_it_has_been_viewed_if_not_logged_in
    setup_mocks
    load_one_child
    @second_page.expects(:on_viewed).never
    
    get :index, {:story_id => '3', :parent_id => '45'}
  end
  
  #---------------------------------------------------------------
  # NEW
  #---------------------------------------------------------------
  
  def test_new_requires_login
    setup_mocks
    assert_requires_login do
      get :new, {:story_id => '3', :parent_id => '45'}
    end
  end
  
  #---------------------------------------------------------------
  # CREATE
  #---------------------------------------------------------------
  
  def test_create_requires_login
    setup_mocks
    assert_requires_login do
      post :create, {:story_id => '3', :parent_id => '45'}
    end
  end
  
  def test_create_without_text_generates_error
    setup_mocks
    login_as_mock @frodo
    post :create, {:story_id => '3', :parent_id => '45'}
    assert_template 'new'
    assert_tag :attributes => {:id => 'errorExplanation'}
  end
  
  def test_create_with_text_saves_page_version_and_redirects_to_parents_index
    setup_mocks
    critic = PageVersion.new
    PageVersion.expects(:new).with({'text' => 'some text'}).returns(critic)
    critic.expects(:story=).with(@story)
    critic.expects(:author=).with(@frodo)
    critic.expects(:parent=).with(@version45)
    critic.stubs(:valid?).returns(true)
    critic.expects(:save).returns(true)
    
    login_as_mock @frodo
    post :create, {:story_id => '3', :parent_id => '45', :page_version => {'text' => 'some text'}}
    assert_redirected_to :controller => 'pages', :action => 'index', :story_id => '3', :parent_id => '45'
  end
  
  #---------------------------------------------------------------
  # STOP FOLLOWING
  #---------------------------------------------------------------
  
  def test_stop_following_requires_login
    setup_mocks
    load_one_child
    assert_requires_login do
      post :stop_following, {:story_id => '3', :parent_id => '45', :id => '20'}
    end
  end
  
  #---------------------------------------------------------------
  # EDIT
  #---------------------------------------------------------------
    
  def test_edit_requires_login
    assert_requires_login do
      get :edit, :id => '1'
    end
  end
  
  def test_edit_displays_edit_form
    login_as :bob
    get :edit, :id => '1'
    assert_tag :tag => 'form', :attributes => {:id => 'edit_page_version_1'}
  end
  
  def test_edit_doesnt_display_edit_form_if_version_has_children
    login_as :bob
    get :edit, :id => '2'
    assert_no_tag :tag => 'form', :attributes => {:id => 'edit_page_version_2'}
  end
  
  def test_admin_can_edit_if_version_has_children
    login_as :admin
    get :edit, :id => '1'
    assert_tag :tag => 'form', :attributes => {:id => 'edit_page_version_1'}
  end
  
  #---------------------------------------------------------------
  # UPDATE
  #---------------------------------------------------------------

  def test_update_requires_login
    assert_requires_login do |proxy|
      proxy.put :update, :id => '1'
    end
  end
  
  def test_update_without_being_the_author_returns_permission_denied
    assert_requires_access(:sam) do |proxy|
      proxy.put :update, :id => '1'
    end
  end
  
  def test_update_without_text_displays_error
    login_as :bob
    put :update, :id => '1', :page_version => {'text' => ''}
    
    assert_response :success
    assert_tag :attributes => {:id => 'errorExplanation'}
  end

  def test_update_with_text_updates_attributes_and_redirects_to_index
    login_as :bob
    put :update, :id => '1', :page_version => {'text' => 'some text'}
    
    assert_equal 'some text', page_versions(:one).reload.text
  end
    
end
