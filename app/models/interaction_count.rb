# == Schema Information
#
# Table name: interaction_counts
#
#  id         :integer(4)      not null, primary key
#  actor_id   :integer(4)
#  subject_id :integer(4)
#  number     :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class InteractionCount < ActiveRecord::Base
  belongs_to :actor, :class_name => 'User', :foreign_key => 'actor_id'
  belongs_to :subject, :class_name => 'User', :foreign_key => 'subject_id'

  validates_presence_of :actor, :subject, :number
  validates_uniqueness_of :subject_id, :scope => :actor_id
  
  def self.find_or_initialise_by_actor_and_subject(actor, subject)
    find(:first, :conditions => {:actor_id => actor.id, :subject_id => subject.id}) || InteractionCount.new(:actor => actor, :subject => subject)
  end
  
  def self.update_for(actor, subject)
    if actor && subject
      count = find_or_initialise_by_actor_and_subject(actor, subject)
      count.number = Interaction.count_for_actor_and_subject(actor, subject)
      count.save!
    end
  end
  
end
