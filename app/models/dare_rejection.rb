# == Schema Information
# Schema version: 258
#
# Table name: dare_rejections
#
#  id                    :integer(11)   not null, primary key
#  dare_challenge_id     :integer(11)   
#  user_id               :integer(11)   
#  rejected_dare_text    :text          
#  rejection_reason_text :text          
#  created_at            :datetime      
#

class DareRejection < ActiveRecord::Base
  belongs_to :dare_challenge
  belongs_to :user
  
  validates_presence_of :dare_challenge, :user
  
  before_create :cache_dare_text
  after_create :notify_darer, :clear_dare_challenge
  
  def darer
    dare_challenge.other_party(user) if dare_challenge
  end
  
  def dare_text
    dare_challenge.dare_for(user) if dare_challenge
  end
  
  protected
  
    def cache_dare_text
      self.rejected_dare_text = dare_text
    end
    
    def notify_darer
      begin
        NotificationsMailer.deliver_dare_rejected(self)
      rescue Net::SMTPSyntaxError
      end
      true
    end
    
    def clear_dare_challenge
      if dare_challenge
        dare_challenge.user_dare_text = nil if dare_challenge.subject == user
        dare_challenge.subject_dare_text = nil if dare_challenge.user == user
        dare_challenge.save!
      end
      true
    end
  
end
