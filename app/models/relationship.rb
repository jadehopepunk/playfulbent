# == Schema Information
# Schema version: 258
#
# Table name: relationships
#
#  id                   :integer(11)   not null, primary key
#  user_id              :integer(11)   
#  subject_id           :integer(11)   
#  relationship_type_id :integer(11)   
#  created_at           :datetime      
#  description          :text          
#

class Relationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, :class_name => 'User', :foreign_key => 'subject_id'
  belongs_to :relationship_type
  
  attr_protected :user, :user_id
  validates_presence_of :user, :subject, :name
  
  after_create :notify_subject_of_create, :ensure_interactions_exist
  after_destroy :ensure_interactions_still_valid  
  
  def self.find_between(user, subject)
    user.relationships.find_by_subject_id(subject.id)
  end
  
  def self.exists_between?(user, subject)
    find_between(user, subject)
  end
  
  def name=(value)
    raise ArgumentError.new("Don't call name without setting a user for this relationship first") unless user
    self.relationship_type = RelationshipType.find_or_initialize_by_name_and_user_id(value, user.id)
  end
  
  def name
    relationship_type.name if relationship_type
  end
  
  def reciprocals
    if !@reciprocals && subject && user
      @reciprocals = subject.relationships.find(:all, :conditions => {:subject_id => user.id})
    end
    @reciprocals
  end
  
  def is_reciprocated?
    reciprocals && !reciprocals.empty?
  end

protected

  def notify_subject_of_create
    begin
      NotificationsMailer.deliver_new_relationship(self)
    rescue Net::SMTPSyntaxError
    end
    true
  end
  
  def ensure_interactions_exist
    InteractionIsFriendOf.ensure_created(subject, user)
    InteractionFriendsWith.ensure_created(user, subject)
    true
  end
  
  def ensure_interactions_still_valid
    InteractionIsFriendOf.ensure_still_valid(subject, user)
    InteractionFriendsWith.ensure_still_valid(user, subject)
    true
  end
  
end
