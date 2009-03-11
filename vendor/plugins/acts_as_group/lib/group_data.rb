
class GroupData
  include WhiteListHelper
  include ActionView::Helpers::TextHelper
  
  ACCESS_LEVELS = {'off' => 1, 'members' => 2, 'anyone' => 3}
  
  attr_accessor :name, :description, :archive_access_level, :members_list_access_level, :external_member_count
  
  def html_name=(value)
    require 'htmlentities'
    coder = HTMLEntities.new
    self.name = coder.decode(value)
  end
  
  def html_description=(value)
    self.description = white_list(value) do |node, bad| 
      white_listed_bad_tags.include?(bad) ? nil : (node.tag? ? nil : node.to_s)
    end
  end
    
  def to_hash
    methods_as_hash [:name, :description, :archive_access_level, :members_list_access_level, :external_member_count]
  end
  
  def minimum_archive_access_level=(value)
    self.archive_access_level = best_access_level(archive_access_level, value)
  end
  
  def minimum_members_list_access_level=(value)
    self.members_list_access_level = best_access_level(members_list_access_level, value)
  end
  
  protected
  
    def methods_as_hash(methods)
      results = {}
      for method in methods
        results[method] = send(method)
      end
      results
    end
  
    def best_access_level(old_level, new_level)
      new_score = score_for_access_level(new_level)
      old_score = score_for_access_level(old_level)

      new_score > old_score ? new_level : old_level
    end
  
    def score_for_access_level(value)
      value && ACCESS_LEVELS[value] ? ACCESS_LEVELS[value] : 0
    end
  
end