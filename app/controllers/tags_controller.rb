class TagsController < ApplicationController
  before_filter :store_location, :only => [:show]
  
  def show
    @tag = Tag.find_by_name(params[:id])
    if @tag
      @stories = @tag.stories.find(:all, :limit => 5)
      @profiles = @tag.profiles.find(:all, :limit => 12, :conditions => 'disabled != 1')
      @gallery_photos = @tag.gallery_photos.find(:all, :limit => 12)
      @dare_responses = DareResponse.find(:all, 
        :include => :dare, 
        :joins => "LEFT JOIN taggings ON taggings.taggable_id = dares.id", 
        :conditions => "taggings.taggable_type = 'Dare' AND taggings.tag_id = #{@tag.id}",
        :limit => 5,
        :order => 'base_dare_responses.created_on DESC')
      @blog_articles = []
    else
      redirect_to '/'
    end
  end
  
end
