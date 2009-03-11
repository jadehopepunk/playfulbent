# == Schema Information
# Schema version: 258
#
# Table name: dares
#
#  id                   :integer(11)   not null, primary key
#  request              :text          
#  requires_photo       :boolean(1)    
#  requires_description :boolean(1)    
#  created_on           :datetime      
#  creator_id           :integer(11)   
#  responded_to         :boolean(1)    
#  expired              :boolean(1)    
#

class Dare < ActiveRecord::Base
  acts_as_taggable
  
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  
  has_many :responses, :class_name => 'DareResponse', :order => 'created_on DESC'
  has_many :activity_created_dares, :dependent => :destroy
  
  validates_presence_of :request, :creator
  validate_on_create :open_slots_available, :your_first_open_dare
  
  after_save :notify_if_expired
  after_create :create_activity

  MAX_OPEN = 6
  
  def self.popular_ranked_tags(limit)
    TagRank.find(:all, :limit => limit, :order => 'dare_count DESC', :conditions => 'dare_count > 0')
  end
  
  def self.find_open
    find(:all, :order => 'created_on DESC', :conditions => is_open)
  end
  
  def self.find_with_responses
    find(:all, :order => 'created_on DESC', :conditions => has_responses)
  end
  
  def self.count_open
    count(:conditions => is_open)
  end
  
  def self.available_slot_count
    MAX_OPEN - count_open
  end
  
  def self.available_slots?
    available_slot_count > 0
  end
  
  def proof_string
    parts = []
    parts << 'upload a photo' if requires_photo
    parts << 'describe how it felt' if requires_description
    return "either upload a photo, or describe how it felt" if parts == []
    parts.join ' and '
  end

  def open_slots_available
    errors.add_to_base "You can't start any new dares until someone completes one of the current ones." if self.class.count_open >= MAX_OPEN
  end

  def owners
    ([creator] + responses.collect(&:user)).uniq
  end
  
  def url
    "http://#{ActionController::UrlWriter.default_url_options[:host]}/dares/#{to_param}" unless new_record?
  end
  
  def title
    request
  end
  
  def expire
    @became_expired = true if !expired
    self.expired = true
  end
  
  def should_expire?
    (created_on <= 3.weeks.ago) && !responded_to
  end
  
  def creator_name
    creator.name if creator
  end
  
protected

  def self.is_open
    "responded_to != 1 AND expired != 1"
  end

  def self.has_responses
    "responded_to = 1"
  end
  
  def notify_if_expired
    if @became_expired
      begin
        NotificationsMailer.deliver_dare_expired(self)
      rescue Net::SMTPSyntaxError
      end
    end
  end
  
  def your_first_open_dare
    if self.class.count(:conditions => [self.class.is_open + " AND creator_id = ?", creator_id]) > 0
      errors.add_to_base "You can only have one dare open at a time, give someone else a go."
    end
  end
  
  def create_activity
    ActivityCreatedDare.create_for(self)
  end

end
