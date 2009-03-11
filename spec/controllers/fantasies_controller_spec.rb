require File.dirname(__FILE__) + '/../spec_helper'

describe FantasiesController, "index" do
  integrate_views
  
  it "should display page" do
    get :index
    response.should be_success
  end
  
end

describe FantasiesController, "new" do
  integrate_views
  
  it "should display page" do
    get :new
    response.should be_success
  end
  
end

describe FantasiesController, "create" do
  integrate_views
  
  before do
    @user = model_factory.user
  end
  
  it "should display new form if details invalid" do
    login @user
    post :create
    
    response.should be_success
  end
  
  it "should save the fantasy if details are valid" do
    login @user
    post :create, :fantasy => {'description' => 'I want to masturbate in public'}    
    Fantasy.find_by_description('I want to masturbate in public').should_not be_nil
  end
  
  it "should redirect to index if details are valid" do
    login @user
    post :create, :fantasy => {'description' => 'I want to masturbate in public'}    
    
    response.should redirect_to(fantasies_path)
  end
  
end