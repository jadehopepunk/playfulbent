require File.dirname(__FILE__) + '/../unit_test_helper'
require 'stories_controller'

# Re-raise errors caught by the controller.
class StoriesController; def rescue_action(e) raise e end; end

class StoriesControllerTest < Test::Unit::TestCase
  
  def setup
    @controller = StoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @frodo = User.new(:nick => 'frodo', :created_on => Time.now)
    @frodo.stubs(:new_record?).returns(false)
  end
  
  def story(id, title)
    s = Story.new(:title => title)
    s.stubs(:id).returns(id)
    s.stubs(:author).returns(@frodo)
    s
  end

  def test_that_index_displays_stories_as_html
    get :index
    assert_tag :attributes => {:id => 'story_1'}
    assert_tag :attributes => {:id => 'story_2'}
  end
  
  # def test_that_index_displays_stories_as_rss
  # 
  #   accept "application/rss"
  #   get :index
  # 
  #   assert_tag :attributes => {:id => 'story_3'}
  # end
  
  def test_new_requires_login
    assert_requires_login do
      get :new
    end
  end
  
  def test_create_requires_login
    assert_requires_login do
      post :create
    end
  end
  
  def test_create_displays_errors_if_missing_fields
    login_as_mock @frodo
    post :create, {:title => 'some story'}
    assert_tag :attributes => {:id => 'errorExplanation'}
  end
  
  def test_create_creates_new_story
    values = {'title' => 'some story', 'first_page_text' => 'fishguts'}
    new_story = Story.new
    
    Story.expects(:new).with(values).returns(new_story)
    new_story.expects(:author=).with(@frodo)
    new_story.expects(:valid?).returns(true)
    new_story.expects(:save)
    new_story.stubs(:page_versions).returns([PageVersion.new])
    
    login_as_mock @frodo
    post :create, {'story' => values}
  end

end
