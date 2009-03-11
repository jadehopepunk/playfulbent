
class SessionsController < ApplicationController

  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    
    if logged_in?
      redirect_to_return_page
      flash[:notice] = { :heading => "Login Successful", :type => "success" }
    else
      @error = "Couldn't log you in. Either you're an Evil Hacker<tm>, or you typed your password wrong. Don't forget to check CAPS LOCK."
      
      respond_to do |format|
        format.html { render :action => 'new' }
        format.js do
          render :update do |page|
            page.replace 'login_form', :partial => 'login_form'
          end
        end
      end
    end
  end

  def destroy
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to_return_page
  end
  
  protected
  
    def redirect_to_return_page
      params[:return_to].blank? ? redirect_back_or_default('/') : redirect_to(params[:return_to])
    end
  
end
