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

class InteractionExchangeMessages < Interaction
  
  def self.meets_criteria?(actor, subject)
    return false unless arguments_valid?(actor, subject)
    Message.exists?(:sender_id => actor.id, :recipient_id => subject.id) && Message.exists?(:sender_id => subject.id, :recipient_id => actor.id)
  end
  
  def message_count
    Message.count(:conditions => {:sender_id => actor.id, :recipient_id => subject.id}) + Message.count(:conditions => {:sender_id => subject.id, :recipient_id => actor.id})
  end
  
end
