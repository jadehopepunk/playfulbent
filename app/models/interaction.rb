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

class Interaction < ActiveRecord::Base
  belongs_to :actor, :class_name => 'User', :foreign_key => 'actor_id'
  belongs_to :subject, :class_name => 'User', :foreign_key => 'subject_id'
  
  validates_presence_of :actor, :subject
  after_create :update_interaction_count

  def self.create_if_meets_criteria(actor, subject)
    if meets_criteria?(actor, subject) && !exists_for(actor, subject)
      create(:actor => actor, :subject => subject)
    end
  end
  
  def self.ensure_created(actor, subject)
    unless exists_for(actor, subject)
      create(:actor => actor, :subject => subject)
    end
  end
  
  def self.ensure_still_valid(actor, subject)
    interaction = find_for_actor_and_subject(actor, subject)
    if interaction
      interaction.destroy unless interaction.meets_criteria?
    end
  end
  
  def self.exists_for(actor, subject)
    !find_for_actor_and_subject(actor, subject).nil?
  end
  
  def self.find_for_actor_and_subject(actor, subject)
    return nil if actor.nil? || subject.nil? || actor.new_record? || subject.new_record?
    find(:first, :conditions => {:actor_id => actor.id, :subject_id => subject.id})
  end
  
  def meets_criteria?
    self.class.meets_criteria?(actor, subject)
  end
  
  def self.count_for_actor_and_subject(actor, subject)
    count(:conditions => {:actor_id => actor.id, :subject_id => subject.id})
  end
  
  protected
  
    def self.arguments_valid?(actor, subject)
      actor && !actor.new_record? && subject && !subject.new_record?
    end
    
    def update_interaction_count
      InteractionCount.update_for(actor, subject)
      true
    end
  
end
