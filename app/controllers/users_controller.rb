class UsersController < ApplicationController
  before_filter :login_required, :only => [:update_password]
  in_place_edit_for :user, :email

  def create
    @user = User.new_or_existing_dummy_for(params[:user])
    self.current_user = @user if saved = @user.save
    
    respond_to do |format|
      format.js do
        if saved
          flash[:notice] = {
            :heading => "New Account Created",
            :text => "Welcome to playful-bent! We hope you have as much fun using this site as we had making it.",
            :type => "success"}
          redirect_back_or_default '/'
        else
          render :update do |page|
            page.replace 'signup_form', :partial => 'signup'
          end
        end
      end
    end
    
  end

  def update_password
    @user = User.find(params[:id])
    return permission_denied unless @user.can_be_edited_by?(current_user)
    
    @user.update_attributes(params[:user])
    @saved = @user.save
  end
  
  def update_gender_and_sexuality
    @user = User.find(params[:id])
    @can_edit = @user.can_be_edited_by?(current_user)
    permission_denied and return unless @can_edit
    
    @user.gender_name = params[:user][:common_gender_name] == 'other' ? params[:user][:other_gender_name] : params[:user][:common_gender_name]
    @user.likes_boys = params[:user][:likes_boys]
    @user.likes_girls = params[:user][:likes_girls]
    @user.save!
    @profile = @user.profile

    respond_to :js
  end  

private

  def process_login
    if request.post?
      if session[:user] = User.authenticate(@params[:login_user][:nick], @params[:login_user][:password])

        flash[:notice] = {
          :heading => "Login Successful",
          :type => "success"}
        redirect_back_or_default :controller => 'home', :action => "index"
      else
        @login_user.errors.add_to_base("Login Failed:  Have you entered your login details correctly? Check that caps lock is turned off, and try again.")
        @nick = @params[:login_user][:nick]
      end
    end
  end

  def process_signup
    if request.post? and @signup_user.save
      session[:user] = User.authenticate(@signup_user.nick, @params[:signup_user][:password])
      flash[:notice] = {
        :heading => "New Account Created",
        :text => "Welcome to playful-bent! We hope you have as much fun using this site as we had making it.",
        :type => "success"}
      redirect_back_or_default :action => "welcome"
    end
  end

end
