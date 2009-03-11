class HomeController < ApplicationController
  before_filter :store_location

  def index
    @activities = ActivityGroupArray.new_from_activities(Activity.find(:all, :order => "created_at DESC", :limit => 30))

    respond_to do |format|
      format.html do
        @popular_ranked_tags = Tag.popular_ranked_tags(100)
        @avatars = Avatar.find(:all, :limit => 6, :include => :profile, :order => 'RAND()', :conditions => "avatars.id IS NOT NULL").reject {|avatar| !avatar.profile}
        @gallery_photos = GalleryPhoto.find(:all, :limit => 6, :include => :photo_set, :conditions => "photo_sets.id IS NOT NULL AND photo_sets.viewable_by IS NULL or photo_sets.viewable_by = 'everyone'", :order => 'RAND()')
        @dare_responses = DareResponse.find(:all, :limit => 6, :conditions => "photo IS NOT NULL AND photo != ''", :order => 'RAND()')
        @strip_shows = StripShow.find_for_mixed_genders(6)
        @article = User.find_by_permalink('andale').syndicated_blog.syndicated_blog_articles.find(:first, :order => 'published_at DESC')
      end
      format.rss { render :template => 'home/index.rss.builder', :layout => false }
    end
  end
  
  def about_interactions
  end
  
end
