class PhotosController < ApplicationController
  before_filter :load_tag, :only => [:index]
  
  def index
    conditions = "photo_sets.viewable_by IS NULL OR photo_sets.viewable_by = '' OR photo_sets.viewable_by = 'everyone'"
    conditions = QueryConditions.append(conditions, @tag.taggable_conditions('GalleryPhoto')) unless @tag.nil?
    @photos = GalleryPhoto.paginate(:all, :conditions => conditions, :include => :photo_set, :order => 'created_on DESC', :per_page => 56, :page => params[:page].to_i || 1)
    @popular_tags = GalleryPhoto.popular_ranked_tags(DEFAULT_TAG_CLOUD_SIZE)
  end
  
end
