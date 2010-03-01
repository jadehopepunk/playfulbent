# == Schema Information
#
# Table name: interactions
#
#  id         :integer(4)      not null, primary key
#  actor_id   :integer(4)
#  subject_id :integer(4)
#  type       :string(255)
#  created_at :datetime
#


class InteractionIsFriendOf < Interaction
  
  def self.meets_criteria?(actor, subject)
    return false unless arguments_valid?(actor, subject)
    Relationship.exists_between?(subject, actor)
  end
  
end
