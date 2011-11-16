# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  before_filter :load_page_title, :set_login_timestamp
    
protected

  def load_page_title
    @page_title = "Playful Bent - Stripping, Dares, Erotic Stories and a Playful Adult Community"
  end

  def permission_denied
    render :text => 'Access Denied', :status => 401
  end

  def zero_or_id(model)
    (model.nil? ? 0 : model)
  end  
  
  def add_rss(title)
    @rss_title = title
    add_alternate title, 'application/rss+xml', :rss
  end
  
  def add_alternate(title, format_type, extension)
    @alternate_formats = [] if @alternate_formats.nil?
    
    @alternate_formats << {'title' => title, 'type' => format_type, 'href' => url_for(params.merge(:format => extension))}
  end
  
  def base_url
    url_for(:controller => 'home', :action => 'index')
  end
  
  def redirect_base_page_to(url)
    respond_to do |format|
      format.html { redirect_to url }
      format.js do
        render :update do 
          |page| page << "window.location = '#{url}'"
        end
      end
    end
  end
  
  def load_tag
    if params[:tag]
      @tag = Tag.find_by_name(params[:tag])
      return @tag
    end
    true
  end
  
  def load_order
    if params[:order]
      @order = params[:order].to_sym
    end
    true
  end
  
  def load_filters
    @filters = []
    if params[:filter]
      @filters = params[:filter].split(':').map(&:to_sym)
    end
    true
  end
    
  def page_version_url(version)
    child_pages_url(:story_id => version.story, :parent_id => zero_or_id(version.parent))
  end
  
  helper_method :is_admin?
  
  def default_url_options(options = {})
    {:host => default_host}
  end
  
  def default_host
    DEFAULT_HOST
  end
  helper_method :default_host
  
  def looks_like_an_email?(value)
    value && value.strip =~ /^[^\s@]*@[^\s@]*$/
  end
  
  def set_login_timestamp
    current_user.on_login if logged_in?
    true
  end
  
end