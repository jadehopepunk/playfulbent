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

class InteractionMutualCrush < Interaction
  
  def self.meets_criteria?(actor, subject)
    actor && subject && (crush = actor.crush_on(subject)) && crush.is_reciprocated?
  end
  
end
