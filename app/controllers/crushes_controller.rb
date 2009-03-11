class CrushesController < ApplicationController
  before_filter :login_required, :except => [:new, :possible_subjects]
  before_filter :admin_required, :only => :index
  before_filter :load_subject, :only => [:new, :create]
  before_filter :load_crush, :only => [:show, :edit, :update, :destroy]
  
  def index
    @crushes = Crush.find(:all, :order => 'created_at DESC')
  end
  
  def show
    @reciprocal_crush = @crush.reciprocal
    
    respond_to do |format|
      format.html do
        if @reciprocal_crush
          render :template => 'crushes/show_reciprocated'
        end
      end
    end
  end
  
  def new
    @crush = Crush.new
    @crush.subject = @subject
    
    if !@crush.subject && !params['query'].blank?
      if looks_like_an_email?(params['query'])
        @email = params['query'].strip
        @crush.subject = User.new_dummy_or_existing_for(@email)
      else
        @users = User.find_for_search_string(params['query'], :limit => 5, :order => 'nick')
        @crush.subject = @users.first if @users.length == 1 && @users.first.nick == params['query']
      end
    end
    
    respond_to :html, :js
  end
  
  def create
    @crush = Crush.new(params[:crush])
    @crush.subject = @subject
    @crush.user = current_user
    raise ActiveRecord::RecordNotFound unless @crush.subject
    
    success = @crush.save
    
    respond_to do |format|
      format.html do
        if success
          redirect_to crush_path(@crush)
        else
          render :action => 'new'
        end
      end
    end
  end
  
  def edit
  end
  
  def update
    success = @crush.update_attributes(params[:crush])
    
    respond_to do |format|
      format.html do
        if success
          redirect_to crush_url(@crush)
        else
          render :action => 'edit'
        end
      end
    end
  end
  
  def destroy
    @crush.destroy
    
    respond_to do |format|
      format.html { redirect_to @crush.subject.profile_url }
    end
  end
    
  protected
  
    def load_subject
      @subject = User.find(params[:subject_id]) unless params[:subject_id].blank?
    end
  
    def load_crush
      @crush = current_user.crushes.find(params[:id])
    end
  
end
