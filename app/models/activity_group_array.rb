
class ActivityGroupArray < Array
  
  def self.new_from_activities(activities)
    result = ActivityGroupArray.new
    for activity in activities
      result.add_activity(activity)
    end
    result
  end
  
  def add_activity(activity)
    unless add_to_existing_group(activity)
      self << ActivityGroup.new(activity)
    end
  end
  
  protected
  
    def add_to_existing_group(activity)
      last && last.add_if_related(activity)
    end
  
end