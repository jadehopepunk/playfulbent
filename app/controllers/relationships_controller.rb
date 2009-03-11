class RelationshipsController < UserBaseController
  before_filter :login_required, :only => [:new, :create, :edit, :update, :destroy, :reorder]
  before_filter :current_user_can_edit_user, :only => [:new, :create, :edit, :update, :destroy, :reorder]
  before_filter :load_relationship, :only => [:edit, :update, :destroy]
  
  def index
    @users = []
    @relationship = Relationship.new
    @relationship_types = @user.relationships_by_name
    
    @page_title = "#{@profile.title}'s Friends | Playful Bent"
        
    if logged_in?
      @users_relationship_with_you = Relationship.find_between(@user, current_user)
      @your_relationship_with_user = Relationship.find_between(current_user, @user)
    end
  end
  
  def new
    @relationship = Relationship.new
    
    if !params[:subject_id].blank?
      @users = [User.find(params[:subject_id])]
    else
      @users = User.find_for_search_string(params['user_search_string'], :limit => 6, :order => 'nick')
    end
    
    @relationship.subject = @users.first if @users.length == 1
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @relationship = Relationship.new
    @relationship.user = @user
    @relationship.attributes = params[:relationship]
    @users = []
    @users << @relationship.subject if @relationship.subject
    
    respond_to do |format|
      format.html do
        if @relationship.save
          back_to_index
        else
          render :action => :new
        end
      end
    end
  end
  
  def edit
    respond_to :html
  end
  
  def update
    @relationship.update_attributes params[:relationship]
    
    respond_to do |format|
      format.html { back_to_index }
    end
  end
  
  def destroy
    @relationship.destroy
    
    respond_to do |format|
      format.html { back_to_index }
    end
  end
  
  def reorder
    params[:relationship_types].each_with_index do |id, index|
      relationship_type = @user.relationship_types.find(id)
      relationship_type.position = (index.to_i + 1)
      relationship_type.save!
    end
    
    render :nothing => true
  end
  
  protected
  
    def load_relationship
      @relationship = Relationship.find(params[:id])
    end
    
    def back_to_index
      redirect_to user_relationships_path(@user)
    end
  
end
