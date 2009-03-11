# == Schema Information
# Schema version: 258
#
# Table name: interactions
#
#  id         :integer(11)   not null, primary key
#  actor_id   :integer(11)   
#  subject_id :integer(11)   
#  type       :string(255)   
#  created_at :datetime      
#

class InteractionWriteInSameStory < Interaction
  
  def self.meets_criteria?(actor, subject)
    return false unless arguments_valid?(actor, subject)

    for story in subject.stories
      return true if story.has_author?(actor)
    end
    false
  end
  
end
