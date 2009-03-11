require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController, "create action with valid login" do
  
  before do
    @user = mock_model(User, {:on_login => nil})
    User.should_receive(:authenticate).with('craig', 'pass').and_return(@user)
  end
  
  it "should set current user" do
    controller.should_receive(:current_user=).with(@user)
    post :create, :login => 'craig', :password => 'pass'
  end
  
  it "should redirect to home page if details are valid" do
    post :create, :login => 'craig', :password => 'pass'
    response.should redirect_to('/')
  end
  
end

describe SessionsController, "create action with invalid login" do
  
  before do
    @user = mock_model(User, :on_login => nil)
    User.should_receive(:authenticate).with('craig', 'wrongpass').and_return(nil)
  end
  
  it "should set current user to nil" do
    controller.should_receive(:current_user=).with(nil)
    post :create, :login => 'craig', :password => 'wrongpass'
  end
  
  it "should render new template" do
    post :create, :login => 'craig', :password => 'wrongpass', :format => 'html'
    response.should render_template('new')
  end
  
end

describe SessionsController, "destroy action" do
  
  it "should clear current user" do
    controller.should_receive(:reset_session)
    delete :destroy
  end
  
  it "should set a notice in the flash" do
    delete :destroy
    flash[:notice].should == "You have been logged out."
  end
  
  it "should redirect to home page" do
    delete :destroy
    response.should redirect_to('/')
  end  
end

describe SessionsController, "destroy action with return_to parameter" do
  
  it "should redirect to the url specified in the return to parameter" do
    delete :destroy, :return_to => '/some/page'
    response.should redirect_to('/some/page')
  end
  
end






