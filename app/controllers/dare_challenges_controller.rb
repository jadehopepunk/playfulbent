class DareChallengesController < ApplicationController
  before_filter :store_location, :only => [:new, :show]
  before_filter :login_required, :except => [:new, :possible_subjects]
  before_filter :admin_required, :only => [:index]
  before_filter :load_dare_challenge, :only => [:show, :update, :reject]
  
  def index
    @dare_challenges = DareChallenge.find(:all, :order => 'created_at DESC')
  end
  
  def new
    @dare_challenge = DareChallenge.new
    @dare_challenge.user = current_user if logged_in?
    @dare_challenge.subject = User.find(params[:subject_id]) unless params[:subject_id].blank?
    
    respond_to do |format|
      format.html do
        unless @dare_challenge.subject
          render :template => 'dare_challenges/new_without_subject'
        end
      end
    end
  end
  
  def possible_subjects
    if looks_like_an_email?(params['user_search_string'])
      @email = params['user_search_string'].strip
      @dare_challenge = DareChallenge.new
      @dare_challenge.user = current_user if logged_in?
      @dare_challenge.subject = User.new_dummy_or_existing_for(@email)
    else
      @users = User.find_for_search_string(params['user_search_string'], :limit => 5, :order => 'nick')
    end
  end
  
  def create
    @email = params[:email].strip unless params[:email].blank?
    @dare_challenge = DareChallenge.new(params[:dare_challenge])
    @dare_challenge.subject = User.new_dummy_or_existing_for(@email) if @email
    @dare_challenge.user = current_user
    
    success = @dare_challenge.save
    
    respond_to do |format|
      format.html do
        if success
          redirect_to dare_challenge_path(@dare_challenge)
        else
          render :action => 'new'
        end
      end
    end
  end
  
  def show
    @other_party = @dare_challenge.other_party(current_user)
    @your_dare_text = @dare_challenge.dare_for(current_user)
    as_subject = (@dare_challenge.subject == current_user)
    
    respond_to do |format|
      format.html do
        if @dare_challenge.rejected?
          render(:template => 'dare_challenges/rejected_dare')
        elsif @dare_challenge.dare_is_rejected_by?(current_user)
          render(:template => 'dare_challenges/awaiting_replacement_dare')
        elsif @dare_challenge.dare_is_rejected_by?(@other_party)
          @dare_rejection = @dare_challenge.dare_rejection_for(@other_party)
          render(:template => 'dare_challenges/provide_replacement_dare')
        elsif !@dare_challenge.subject_has_responded?
          if as_subject
            render(:template => 'dare_challenges/let_subject_respond')
          else
            render(:template => 'dare_challenges/waiting_for_subject_response')
          end
        elsif !@dare_challenge.user_has_responded?
          if as_subject
            render(:template => 'dare_challenges/waiting_for_user_dare')
          else
            render(:template => 'dare_challenges/let_user_respond')
          end
        elsif !@dare_challenge.both_parties_complete?
          if !@dare_challenge.has_completed_dare?(current_user)
            render(:template => 'dare_challenges/awaiting_your_dare_response')
          else
            render(:template => 'dare_challenges/awaiting_their_dare_response')
          end
        else
          # render show
        end
      end
    end
  end
  
  def update
    if current_user == @dare_challenge.subject
      saved = @dare_challenge.update_with_subject_response(params[:dare_challenge])
      template = 'let_subject_respond'
    elsif current_user == @dare_challenge.user
      return access_denied unless @dare_challenge.subject_has_responded?
      template = 'let_user_respond'
      saved = @dare_challenge.update_with_user_response(params[:dare_challenge])      
    end
    
    respond_to do |format|
      format.html do
        if saved
          redirect_to dare_challenge_path(@dare_challenge)
        else
          render(:template => "dare_challenges/#{template}")
        end
      end
    end
  end
  
  def reject
    @dare_challenge.reject
    
    respond_to do |format|
      format.html { redirect_to dare_challenge_path(@dare_challenge) }
    end
  end
  
  protected
  
    def load_dare_challenge
      @dare_challenge = DareChallenge.find(params[:id])
      return access_denied unless @dare_challenge.can_be_viewed_by?(current_user)
    end

end
