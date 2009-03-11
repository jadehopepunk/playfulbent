class ProfilesController < ApplicationController
  include ProfileTabs
  
  before_filter :store_location, :only => [:show, :index]
  before_filter :login_required, :except => [:show, :index]
  before_filter :load_profile, :except => [:index, :create]
  before_filter :profile_must_be_editable, :only => [:disable, :enable]
  before_filter :load_tag, :only => [:index]
  before_filter :load_order, :only => [:index]

  def index
    @order = :recently_logged_in if @order.nil? || (@order == :most_interactions_with_you && !logged_in?)
  
    includes = [:avatar]
    select = nil
  
    conditions = QueryConditions.append(conditions, "profiles.published = 1 AND profiles.disabled != 1")
    conditions = QueryConditions.append(conditions, @tag.taggable_conditions('Profile')) unless @tag.nil?

    case @order
      when :most_interactions_with_you
        conditions = QueryConditions.append(conditions, "(profiles.id != #{current_user.id} AND interaction_counts.actor_id = #{current_user.id})")
        includes << {:user => [:sponsorship, :interaction_counts_as_subject]}
      when :recently_added
        includes << {:user => :sponsorship}
      when :recently_logged_in
        includes << :user
    end
    
    unless params[:show_all]
      conditions = QueryConditions.append(conditions, "avatars.id IS NOT NULL")
    end
    
    unless params[:query].blank?
      conditions = QueryConditions.append(conditions, 
        QueryConditions.for_search('users.nick', params[:query])
      )
    end
    
    @profiles = Profile.paginate :conditions => conditions, :order => profile_order_statement(@order), :per_page => 10, :page => params[:page], :include => includes

    @popular_ranked_tags = Profile.popular_ranked_tags(DEFAULT_TAG_CLOUD_SIZE)
    @possible_orders = [:recently_logged_in, :recently_added, :most_interactions_with_you]

    @page_title = "Playful adult profiles and social networking | Playful Bent"
    
    respond_to :html
  end

  def show  
    @can_edit = @profile.can_be_edited_by?(current_user)
    @avatar = @profile.avatar
    @user = @profile.user
    
    @subject = @profile
    @conversation = Conversation.find_for(@subject)
    @location = @profile.location
    @gallery_photos = @profile.display_photos

    load_profile_tabs(:profiles)
    
    @page_title = "#{@profile.title}'s Profile | Playful Bent"
    
    respond_to do |format|
      format.html do
        render :template => 'profiles/_show_disabled' if @profile.disabled?
      end
    end
  end
  
  def create
    return access_denied unless current_user.profile.nil?
    @profile = Profile.new
    @profile.user = current_user
    @profile.save
    redirect_to @profile.url
  end
  
  def update_welcome_text
    return unless update_profile
    
    respond_to :js
  end
  
  def update_interests
    return unless update_profile
    
    respond_to :js
  end

  def update_kinks
    return unless update_profile
    
    respond_to :js
  end
  
  def disable
    @profile.disabled = true
    @profile.save!
    
    respond_to do |format|
      format.html { redirect_to @profile.url }
    end
  end
  
  def enable
    @profile.disabled = false
    @profile.save!
    
    respond_to do |format|
      format.html { redirect_to @profile.url }
    end
  end
  
private

  def update_profile
    @can_edit = @profile.can_be_edited_by?(current_user)
    return access_denied unless @can_edit
    
    @profile.update_attributes(params[:profile])
    true
  end
  
  def load_profile
    if uses_integer_profile_id?
      @profile = Profile.find(profile_id_param)
      redirect_to @profile.url
      return false
    else
      @profile = Profile.find_by_param(profile_id_param)
    end
    @user = @profile.user
    return !@profile.nil?
  end
  
  def own_profile?
    @user == current_user
  end
  helper_method :own_profile?
  
  def profile_id_param
    (request.subdomains.first.nil? || request.subdomains.first == 'www') ? params[:id] : request.subdomains.first
  end
  
  def uses_integer_profile_id?
    (request.subdomains.first.nil? || request.subdomains.first == 'www') && params[:id].to_i.to_s == params[:id]
  end
  
  def profile_must_be_editable
    return access_denied unless @profile.can_be_edited_by?(current_user)
  end

  def profile_order_statement(order_name)
    case order_name
      when :recently_added
        'profiles.created_on DESC'
      when :recently_logged_in
        'users.last_logged_in_at DESC, profiles.created_on DESC'
      when :most_interactions_with_you
        'interaction_counts.number DESC, profiles.created_on ASC'
    end
  end
    
  
end
