# == Schema Information
# Schema version: 258
#
# Table name: crushes
#
#  id         :integer(11)   not null, primary key
#  user_id    :integer(11)   
#  subject_id :integer(11)   
#  fantasy    :text          
#  created_at :datetime      
#  updated_at :datetime      
#

class Crush < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, :class_name => 'User', :foreign_key => :subject_id
  
  validates_uniqueness_of :subject_id, :scope => :user_id
  validates_presence_of :user, :subject, :fantasy
  
  attr_protected :user_id, :subject_id
  
  after_create :create_interaction_if_reciprocated, :send_notifications
  
  def is_reciprocated?
    reciprocal
  end
  
  def reciprocal
    subject.crush_on(user)
  end
  
  protected
  
    def create_interaction_if_reciprocated
      InteractionMutualCrush.create_if_meets_criteria(user, subject)
      InteractionMutualCrush.create_if_meets_criteria(subject, user)
      true
    end
    
    def send_notifications
      if is_reciprocated?
        begin
          NotificationsMailer.deliver_new_mutual_crush(self)
        rescue Net::SMTPSyntaxError
        end
      else
        begin
          NotificationsMailer.deliver_someone_has_a_crush_on_you(self)
        rescue Net::SMTPSyntaxError
        end
      end
      true
    end
  
end
