class DareResponsesController < ApplicationController
  before_filter :store_location, :only => [:index, :show]
  before_filter :load_tag, :only => :index
  before_filter :login_required, :only => [:create]
  before_filter :load_filters, :only => :index
  
  def index
    @open_dares = Dare.find_open
    @popular_tags = Dare.popular_ranked_tags(DEFAULT_TAG_CLOUD_SIZE)
    @possible_filters = [[:girls, 'Girls'], [:boys, 'Boys']]
    @possible_filters << [:my_friends, 'My Friends'] if logged_in?
        
    feed_title = 'Playful Bent - Recent Dare Responses'
    
    add_rss feed_title
    index_params = {:order => 'base_dare_responses.created_on DESC'}
    unless @tag.nil?
      index_params[:conditions] = @tag.taggable_conditions('Dare')
      index_params[:include] = :dare
    end
    
    respond_to do |format|
      format.html do
        @dare_responses = DareResponse.filter_by(@filters, current_user).paginate(:all, {:per_page => 10, :page => params[:page]}.merge(index_params))
      end
      format.rss do
        @dare_responses = DareResponse.find(:all, index_params)
        render :xml => DareResponse.collection_to_rss(feed_title, @dare_responses, base_url)
      end
    end
  end
    
  def new
    @dare = Dare.find(params[:dare_id])
    @dare_response = DareResponse.new    
  end
  
  def create
    @dare = Dare.find(params[:dare_id])
    @dare_response = DareResponse.new(params[:dare_response])
    @dare_response.dare = @dare
    @dare_response.user = current_user
    if @dare_response.save
      redirect_to dare_url(@dare)
    else
      render :action => 'new'
    end    
  end
    
end
