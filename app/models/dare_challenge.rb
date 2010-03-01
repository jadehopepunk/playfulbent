# == Schema Information
#
# Table name: dare_challenges
#
#  id                :integer(4)      not null, primary key
#  user_id           :integer(4)
#  subject_id        :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#  dare_level        :string(255)     default("flirty")
#  subject_dare_text :text
#  user_dare_text    :text
#  response_added_at :datetime
#  rejected_at       :datetime
#  completed_at      :datetime
#

class DareChallenge < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, :class_name => 'User', :foreign_key => :subject_id
  has_many :responses, :class_name => 'DareChallengeResponse', :foreign_key => :dare_challenge_id
  
  validates_presence_of :user, :subject
  validates_presence_of :dare_level, :subject_dare_text, :if => :as_subject_response?
  validates_presence_of :user_dare_text, :if => :as_user_response?
  validates_associated :subject
  validate_on_create :cant_challenge_yourself, :one_challenge_at_a_time
  
  after_create :notify_subject
  before_update :update_dare_timestamps
  
  attr_accessor :status

  def can_be_viewed_by?(viewing_user)
    viewing_user && (viewing_user == subject || viewing_user == user || viewing_user.is_admin?)
  end
  
  def subject_has_responded?
    !subject_dare_text.blank?
  end
  
  def user_has_responded?
    !user_dare_text.blank?
  end
  
  def subject_response
    responses.find(:first, :conditions => {:user_id => subject.id}) if subject
  end
  
  def user_response
    responses.find(:first, :conditions => {:user_id => user.id}) if user
  end
  
  def has_completed_dare?(this_user)
    responses.map(&:user).include?(this_user)
  end
  
  def both_parties_complete?
    has_completed_dare?(user) && has_completed_dare?(subject)
  end
  
  def challenge_started?
    subject_has_responded? && user_has_responded?
  end
  
  def rejected?
    rejected_at
  end
  
  def reject
    self.rejected_at = Time.now
    save!
    send_rejected_email
  end
  
  def update_with_subject_response(params)
    self.status = :subject_response
    send_accepted_email if saved = update_attributes(params)
    saved
  end
  
  def update_with_user_response(params)
    self.status = :user_response
    send_dare_emails if saved = update_attributes(params)
    saved
  end
  
  def self.find_current_challenge_between(user1, user2)
    return nil unless user1.id && user2.id
    find(:first, :conditions => ["completed_at IS NULL AND ((user_id = ? AND subject_id = ?) OR (subject_id = ? && user_id = ?)) AND rejected_at IS NULL", user1.id, user2.id, user1.id, user2.id])
  end
  
  def other_party(this_user)
    return subject if this_user == user
    return user if this_user == subject
    nil
  end

  def dare_for(this_user)
    return subject_dare_text if this_user == user
    return user_dare_text if this_user == subject
    nil
  end

  def dare_is_rejected_by?(this_user)
    dare_is_rejected?(this_user, dare_for(this_user))
  end

  def dare_rejection_for(this_user)
    dare_text = dare_for(this_user)
    DareRejection.find(:first, :conditions => ["dare_challenge_id = ? AND user_id = ? AND rejected_dare_text = ?", id, this_user.id, dare_text])
  end
  
  def is_participating?(this_user)
    other_party(this_user)
  end
  
  def on_new_dare_response(dare_challenge_response)
    reload
    if both_parties_complete?
      send_completed_emails
      self.completed_at = Time.now
      save!
    end
  end

  def status_message_as(viewing_user)
    other_party = other_party(viewing_user)
    as_subject = (subject == viewing_user)
    
    if rejected?
      'has been rejected'
    elsif dare_is_rejected_by?(viewing_user)
      "you rejected a dare, awaiting replacement from #{other_party.name}"
    elsif dare_is_rejected_by?(other_party)
      'awaiting a replacement dare from you'
    elsif !subject_has_responded?
      if as_subject
        'will you accept the challenge?'
      else
        'not yet accepted'
      end
    elsif !user_has_responded?
      if as_subject
        "awaiting a dare from #{other_party.name}"
      else
        "waiting for you to choose a dare"
      end
    elsif !both_parties_complete?
      if !has_completed_dare?(viewing_user)
        "waiting for you to do the deed"
      else
        "waiting for #{other_party.name} to do the deed"
      end
    else
      "complete"
    end
  end

  def status_message_as_admin
    if rejected?
      'has been rejected'
    elsif dare_is_rejected_by?(user)
      "#{user.name} rejected a dare, awaiting replacement"
    elsif dare_is_rejected_by?(subject)
      "#{subject.name} rejected a dare, awaiting replacement"
    elsif !subject_has_responded?
      'not yet accepted'
    elsif !user_has_responded?
      'waiting for user to pick a dare'
    elsif !both_parties_complete?
      'waiting for both parties to do the deed'
    else
      "complete"
    end
  end

  protected
  
    def dare_is_rejected?(this_user, dare_text)
      this_user && !dare_text.blank? && DareRejection.exists?(["dare_challenge_id = ? AND user_id = ? AND rejected_dare_text = ?", id, this_user.id, dare_text])
    end
    
    def as_subject_response?
      status == :subject_response
    end
    
    def as_user_response?
      status == :user_response
    end
    
    def update_dare_timestamps
      if as_subject_response?
        self.response_added_at = Time.now
      end
    end
    
    def deliver_ignoring_errors(mail_method, *params)
      begin
        NotificationsMailer.send("deliver_#{mail_method}".to_sym, *params)
      rescue Net::SMTPSyntaxError
      end
    end
    
    def notify_subject
      deliver_ignoring_errors(:new_dare_challenge, self)
    end
    
    def send_rejected_email
      deliver_ignoring_errors(:dare_challenge_rejected, self)
    end
    
    def send_accepted_email
      deliver_ignoring_errors(:dare_challenge_accepted, self)
    end
    
    def send_dare_emails
      deliver_ignoring_errors(:dare_challenge_dare_received, user, subject, subject_dare_text, self)
      deliver_ignoring_errors(:dare_challenge_dare_received, subject, user, user_dare_text, self)      
    end
    
    def send_completed_emails
      deliver_ignoring_errors(:dare_challenge_complete, user, self)
      deliver_ignoring_errors(:dare_challenge_complete, subject, self)      
    end
    
    def cant_challenge_yourself
      if user && user == subject
        errors.add :subject, "is youself."
      end
      true
    end
    
    def one_challenge_at_a_time
      if user && subject
        if DareChallenge.exists?(["user_id = ? AND subject_id = ? AND rejected_at IS NULL AND completed_at IS NULL", user.id, subject.id])
          errors.add :subject, "is already doing a dare challenge with you."
        end
      end
    end
  
end
