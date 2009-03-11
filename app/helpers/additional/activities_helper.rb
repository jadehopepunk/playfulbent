module Additional
  module ActivitiesHelper
  
    def activity_actor_link(activity)
      link_to_profile_for(activity.actor) if activity.actor
    end
    
    def activity_review_link(activity)
      link_to(h(activity.review.product_name), review_path(activity.review)) if activity.review
    end
    
    def activity_gallery_photo_thumbs(activity_group)
      results = activity_group.activities.map { |activity| activity_gallery_photo_thumb(activity) }
      results.join(' ')
    end

    def activity_gallery_photo_thumb(activity)
      image = image_tag(url_for_gallery_photo(activity.gallery_photo, 'thumb'), :alt => h(activity.gallery_photo.title))
      link_to(image, user_photo_set_my_photo_path(activity.gallery_photo.user, activity.gallery_photo.photo_set, activity.gallery_photo))
    end
    
    def activity_strip_show_thumb(activity)
      link_to(strip_show_thumb(activity.strip_show), strip_photo_url(activity.strip_show.first_photo)) if activity.strip_show
    end
  
  end
end