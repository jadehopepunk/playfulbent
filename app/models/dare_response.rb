# == Schema Information
# Schema version: 258
#
# Table name: base_dare_responses
#
#  id                :integer(11)   not null, primary key
#  user_id           :integer(11)   
#  dare_id           :integer(11)   
#  created_on        :datetime      
#  description       :text          
#  photo             :string(255)   
#  type              :string(255)   
#  dare_challenge_id :integer(11)   
#

class DareResponse < BaseDareResponse
  belongs_to :dare
  validates_presence_of :dare
  
  has_many :activity_created_dare_responses, :dependent => :destroy

  after_create :update_interactions, :mark_dare_as_responded_to, :create_activity
  after_destroy :ensure_interactions_still_valid

  def self.find_with_picture(limit = nil)
    find(:all, :order => 'created_on DESC', :conditions => 'photo IS NOT NULL', :limit => limit)
  end

  def self.find_with_text
    find(:all, :order => 'created_on DESC', :conditions => "description != ''")
  end

  def self.responses_with_picture_to(user, options)
    options[:conditions] = ["dares.creator_id = ? AND base_dare_responses.photo IS NOT NULL AND base_dare_responses.photo != ''", user.id]
    options[:order] = "base_dare_responses.created_on DESC"
    options[:include] = :dare
    find(:all, options)
  end

  def self.find_users_responses_to(responder, darer)
    find(:all, :include => :dare, :conditions => ["dares.creator_id = ? AND base_dare_responses.user_id = ?", darer.id, responder.id])
  end

  def self.count_users_responses_to(responder, darer)
    count(:include => :dare, :conditions => ["dares.creator_id = ? AND base_dare_responses.user_id = ?", darer.id, responder.id])
  end

  def self.count_with_photo
    count(:conditions => 'photo IS NOT NULL')
  end

  def self.count_with_description
    count(:conditions => "description IS NOT NULL AND description != ''")
  end

  def darer
    dare.creator if dare
  end

  def dare_requires_photo
    !dare.nil? && dare.requires_photo
  end

  def dare_requires_description
    !dare.nil? && dare.requires_description
  end

  protected

    def update_interactions
      InteractionPerformDare.ensure_created(user, dare.creator)
      InteractionHaveDarePerformed.ensure_created(dare.creator, user)
    end

    def ensure_interactions_still_valid
      InteractionPerformDare.ensure_still_valid(user, dare.creator)
      InteractionHaveDarePerformed.ensure_still_valid(dare.creator, user)
    end

    def mark_dare_as_responded_to
      if dare
        dare.responded_to = true
        dare.save
      end
      true
    end
    
    def create_activity
      ActivityCreatedDareResponse.create_for(self)
      true
    end
  
end
