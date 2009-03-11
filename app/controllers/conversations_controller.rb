class ConversationsController < ApplicationController
  before_filter :login_required, :only => [:new, :create, :edit, :update]
  before_filter :store_location, :only => [:index, :show]
  
  def index
    add_rss "Playful Bent - Forum"

    respond_to do |format|
      format.html do
        @conversations = Conversation.find(:all, :order => 'created_at DESC', :conditions => 'subject_id IS NULL')
      end
      format.rss do
        render :xml => Comment.to_rss(Comment.find(:all, :order => 'created_at DESC', :limit => 100), base_url)
      end
    end
  end

  def new
    @conversation = Conversation.new
    @conversation.user = current_user
    @conversation.set_subject(params[:subject_id], params[:subject_type])
    
    respond_to do |format|
      format.html
      format.js do
        render :update do |page|
          page.replace_html 'new_comment_container', :partial => 'conversations/new'
        end
      end
    end
  end

  def create
    @conversation = Conversation.find_by_subject_id_and_subject_type(params[:conversation][:subject_id], params[:conversation][:subject_type])
    
    if @conversation.nil?
      @conversation = Conversation.new(params[:conversation])
      @conversation.user = current_user
      @saved = @conversation.save
    else
      comment = Comment.new(:user => current_user, :content => params[:conversation][:comment_text])
      @conversation.comments << comment
      @saved = comment.save
    end

    respond_to do |format|
      if @saved
        @subject = @conversation.subject
        
        flash[:notice] = 'Conversation was successfully created.'
        format.html { redirect_to conversation_comments_url(@conversation) }
        format.js do
          render :update do |page|
            page.replace_html 'conversations_container', :partial => 'conversations/show'
          end
        end
      else
        format.html { render :action => "new" }
        format.js do
          render :update do |page|
            page.replace_html 'new_comment_container', :partial => 'new'            
          end
        end
      end
    end
  end


end
