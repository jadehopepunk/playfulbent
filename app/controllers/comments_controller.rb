class CommentsController < ApplicationController
  before_filter :login_required, :only => [:new, :create, :edit, :update]
  before_filter :store_location, :only => [:index, :show]  
  before_filter :load_conversation
  before_filter :load_parent, :only => [:new, :create]
  
  def index
    @conversation.mark_as_read(current_user)
    add_rss "Playful Bent - #{@conversation.title}"

    respond_to do |format|
      format.html do
      end
      format.rss { render :xml => @conversation.to_rss(base_url) }
    end
  end

  def new
    @comment = Comment.new
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @comment.conversation = @conversation
    @saved = @comment.save
    @parent.add_reply(@comment) if @parent && @saved

    respond_to do |format|
      format.html do
        flash[:notice] = 'Comment was successfully created.'
        if @saved
          redirect_to conversation_comments_url(@conversation)
        else
          render :action => "new"
        end
      end
      format.js
    end
  end

  def update
    @comment = Comment.find(params[:id])
    permission_denied && return unless @comment.user == current_user

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to conversation_comment_url(@conversation) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    permission_denied && return unless @comment.user == current_user
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to conversation_comments_url(@conversation) }
    end
  end
  
protected

  def load_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end
  
  def load_parent
    @parent = Comment.find(params[:parent_id]) unless params[:parent_id].blank?
  end
  
end
