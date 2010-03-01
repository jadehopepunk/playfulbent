# == Schema Information
#
# Table name: base_dare_responses
#
#  id                :integer(4)      not null, primary key
#  user_id           :integer(4)
#  dare_id           :integer(4)
#  created_on        :datetime
#  description       :text(16777215)
#  photo             :string(255)
#  type              :string(255)
#  dare_challenge_id :integer(4)
#

class DareChallengeResponse < BaseDareResponse
  belongs_to :dare_challenge
  
  validates_presence_of :dare_challenge
  
  after_create :notify_dare_challenge
  
  def dare_requires_photo
    true
  end
  
  def dare_requires_description
    true
  end

  def darer
    dare_challenge.other_party(user) if dare_challenge && user
  end
  
  protected
  
    def notify_dare_challenge
      dare_challenge.on_new_dare_response(self) if dare_challenge
    end
  
end
