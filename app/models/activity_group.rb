
class ActivityGroup
  attr_accessor :activities
  attr_accessor :activity_class
  
  def initialize(activity)
    self.activity_class = activity.class
    self.activities = [activity]
  end
  
  def add_if_related(activity)
    if activity_class == activity.class && actor == activity.actor && activity_class == ActivityCreatedGalleryPhoto
      activities << activity
      return true
    end
    return false
  end

  def activity_count
    activities.length
  end
  
  def method_missing(name, *args)
    activities.first.send(name, *args)
  end
  
end