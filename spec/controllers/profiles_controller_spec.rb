require File.dirname(__FILE__) + '/../spec_helper'

describe ProfilesController, "index action" do
  
  before do
    @results = [mock_model(Profile, :kink_tags => [Tag.new(:name => 'midgets')])]
    Profile.stub!(:paginate).and_return(@results)
  end
  
  it "should respond with success" do
    get :index
    response.should be_success
    response.should render_template('index')
  end
  
  it "should display profiles" do
    get :index
    assigns(:profiles).length.should == 1
  end
    
end