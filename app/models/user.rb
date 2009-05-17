# == Schema Information
# Schema version: 258
#
# Table name: users
#
#  id                       :integer(11)   not null, primary key
#  nick                     :string(80)    
#  picture                  :string(255)   
#  hashed_password          :string(255)   
#  created_on               :datetime      
#  gender_id                :integer(11)   
#  likes_boys               :boolean(1)    
#  likes_girls              :boolean(1)    
#  is_admin                 :boolean(1)    
#  permalink                :string(255)   
#  updated_at               :datetime      
#  last_logged_in_at        :datetime      
#  is_review_manager        :boolean(1)    
#  primary_email_address_id :integer(11)   
#

require 'digest/sha1'

class User < ActiveRecord::Base
  file_column :picture, :magick => { :geometry => "150x150>", :versions => { "thumb" => "60x60" } }

  belongs_to :gender
  belongs_to :primary_email_address, :class_name => 'EmailAddress', :foreign_key => :primary_email_address_id, :dependent => :destroy
  
  has_one :sponsorship, :conditions => "cancelled_at IS NULL"
  has_one :syndicated_blog
  has_one :profile, :dependent => :destroy
  has_one :flickr_account, :dependent => :destroy
  has_one :fantasy_actor, :dependent => :destroy

  has_many :strip_shows, :conditions => "finished = 1"
  has_many :page_versions, :foreign_key => "author_id"
  has_many :stories, :through => :page_versions, :uniq => true
  has_many :relationships, :dependent => :destroy, :include => [:relationship_type, :subject]
  has_many :relationship_types, :order => 'position'
  has_many :sponsorships
  has_many :dares, :foreign_key => 'creator_id'
  has_many :dare_responses, :order => 'created_on DESC'
  has_many :interactions, :foreign_key => 'actor_id', :dependent => :destroy
  has_many :interactions_as_subject, :foreign_key => 'subject_id', :class_name => 'Interaction', :dependent => :destroy
  has_many :interaction_counts, :foreign_key => 'actor_id', :dependent => :destroy
  has_many :interaction_counts_as_subject, :foreign_key => 'subject_id', :class_name => 'InteractionCount', :dependent => :destroy
  has_many :received_messages, :class_name => 'Message', :foreign_key => 'recipient_id', :order => 'created_on DESC'
  has_many :message_readings
  has_many :strip_show_views, :dependent => :destroy
  has_many :crushes, :dependent => :destroy
  has_many :crushes_as_subject, :class_name => 'Crush', :foreign_key => 'subject_id', :dependent => :destroy
  has_many :reviews
  has_many :email_addresses, :dependent => :destroy
  
  attr_accessor :password
  validates_uniqueness_of :nick, :if => :not_dummy?
  validates_length_of :nick, :within => 3..40, :if => :not_dummy?, :allow_blank => true
  validates_presence_of :nick, :if => :not_dummy?
  validates_presence_of :permalink, :if => :validate_permalink?
  validates_exclusion_of :permalink, :in => %w(admin superuser group groups help support suggestions information mail assets)
  validates_uniqueness_of :permalink, :message => "has already been taken. This is a lowercase version of your nickname containing only letters and numbers. Try adding more letter or numbers to your nickname.", :if => :not_dummy?, :allow_nil => true
  validates_length_of :password, :within => 5..40, :if => :validate_password?, :allow_blank => true
  validates_presence_of :password, :if => :validate_password?
  validates_confirmation_of :password, :if => :validate_password?
  validate :ensure_nick_has_no_underscores
  validates_associated :primary_email_address
  validate :ensure_email_address_is_valid  

  @@salt = 'bootlace_has_a_playfulbent'
  cattr_accessor :salt
  before_validation :calculate_permalink_from_nick
  after_save('@new_password = false')
  after_validation :crypt_password
  after_create :create_profile
  
  attr_accessor :allow_dummy
  attr_protected :is_admin, :allow_dummy, :is_review_manager
  
  alias_method :original_gender, :gender

  named_scope :other_than_user, lambda {|user| {:conditions => ["users.id != ?", user.id]}}
  
  def self.new_or_existing_dummy_for(params)
	  params = {} if params.nil?  
	  result = User.find(:first, :include => :primary_email_address, :conditions => ["(nick = '' OR nick IS NULL) and email_addresses.address = ?", params[:email]]) unless params[:email].blank?
	  result = User.new if result.nil?
    result.attributes = params
	  result
  end
  
  def self.new_dummy_or_existing_for(email_address)
    (!email_address.blank? && User.find_by_email(email_address)) || new_dummy_for(email_address)
  end
  
  def self.new_dummy_for(email_address)
    user = User.new(:email => email_address)
    user.allow_dummy = true
    user
  end
  
  def self.find_by_email(email)
    User.find(:first, :include => :primary_email_address, :conditions => ["email_addresses.address = ?", email])
  end
  
  def dummy?
    allow_dummy || (!new_record? && nick.blank?)
  end
  
  def self.find_for_search_string(search_string, options = {})
    return [] if search_string.blank?

    like_string = "%#{search_string}%"
    conditions = ["nick LIKE ?", like_string]
    User.find(:all, {:conditions => conditions}.merge(options))
  end
  
  def email
    primary_email_address.address if primary_email_address
  end
  
  def email=(value)
    address_record = EmailAddress.new(:address => value)
    self.primary_email_address = address_record
    self.email_addresses << address_record
  end
  
  def find_others_with_minimum_interactions(min_interactions)
    User.find_by_sql("SELECT users.*, count(interactions.id) as interaction_count FROM users LEFT JOIN interactions ON users.id = interactions.subject_id WHERE interactions.actor_id = #{id} AND users.id != #{id} GROUP BY users.id HAVING interaction_count >= #{min_interactions} ORDER BY nick")
  end
  
  def find_others_with_minimum_interactions_or_admin(min_interactions)
    User.find_by_sql("SELECT users.*, count(interactions.id) as interaction_count FROM users LEFT JOIN interactions ON users.id = interactions.subject_id WHERE (interactions.actor_id = #{id} AND users.id != #{id}) OR users.is_admin = 1 OR users.is_review_manager = 1 GROUP BY users.id HAVING interaction_count >= #{min_interactions} ORDER BY nick")
  end
  
  def has_blog?
    !!syndicated_blog
  end
  
  def has_gallery_photos?    
    profile && profile.has_gallery_photos?
  end
  
  def gender
      original_gender.nil? ? Gender.unknown : original_gender
  end
  
  def has_gender?
    original_gender
  end
  
  def avatar_image_url
    profile.nil? ? Avatar.blank_image_url : profile.avatar_image_url
  end
    
  def avatar_thumb_image_url
    profile.nil? ? Avatar.blank_image_url : profile.avatar_thumb_image_url
  end
  
  def has_avatar?
    !profile.nil? && profile.has_avatar?
  end
  
  def html_avatar
    html_image_options = {}
    html_image_options[:size] = '80x80'
    html_image_options[:alt] = nick
    avatar_image = "<img src=\"#{avatar_thumb_image_url}\" alt=\"#{nick}\" style=\"border: 1px solid #000; display: block; margin: 10px 10px 0 10px;\" width=\"80\" height=\"80\" />"
    avatar_name = "<span style=\"width: 100px; display: block;\">#{name}</span>"
    user_styles = 'float: left; margin: 0 10px 10px 0; background: #927B69 url(http://www.playfulbent.com/images/forum/avatar_background.png) top left repeat; border: 3px solid #000; color: #000; text-align: center; line-height: 30px; overflow: hidden; z-index: 1;'
    "<a href=\"#{profile_url}\" style=\"#{user_styles}\">#{avatar_image}<span>#{name}</span></a>"
  end
  
  def profile_url
    return nil if dummy?
    base_host = ActionController::UrlWriter.default_url_options[:host]
    base_host = base_host[4..-1] if base_host.starts_with? 'www.'
    "http://#{permalink}.#{base_host}"
  end
  
  def html_profile_link(contents)
		if profile.nil?
		  name
		else
			link_to name, user.profile_url, :class => 'user'
		end        
  end
  
  def self.authenticate(nick, pass)
    search_nick = nick.gsub(/_/, ' ')
    find(:first, :conditions => ["nick = ? AND hashed_password = ?", search_nick, sha1(pass)])
  end

  def unfinished_stripshow
    StripShow.find(:first, :conditions => ["user_id = ? and finished = 0", id])
  end

  def has_stripshow
    !strip_shows.empty?
  end

  def greatest_stripshow_position_viewed_by(other_user)
    positions = strip_shows.map { |show| show.greatest_position_viewed_by(other_user) }
    positions.empty? ? 0 : positions.max
  end
  
  def greatest_stripshow_position_visible_to(other_user)
    return 1 if other_user == nil || !other_user.has_stripshow
    we_have_seen = [other_user.greatest_stripshow_position_viewed_by(self), 1].max
    return we_have_seen + 1
  end
  
  def all_stripshows_partially_viewed_by(other_user)
    for show in strip_shows
      return false unless show.some_viewed_by(other_user)
    end
    true
  end
  
  def clear_password
    password = password_confirmation = nil
  end
  
  def name
    if nick.blank?
      email
    else
      (nick =~ /[A-Z]/) ? nick : nick.titleize
    end
  end
  
  def playful_email
    "#{permalink}@playfulbent.com" unless permalink.blank?
  end

  def has_interest?(tag)
    profile.nil? ? false : profile.has_interest?(tag)
  end
  
  def has_kink?(tag)
    profile.nil? ? false : profile.has_kink?(tag)
  end
  
  def likes_string
    return "none of your business" if likes_boys.nil? || likes_girls.nil?
    return "no one" if likes.empty?
    likes.join " and "
  end
  
  def likes
    result = []
    result << 'boys' if likes_boys
    result << 'girls' if likes_girls
    result
  end
  
  def has_sexuality?
    !likes_boys.nil? && !likes_girls.nil?
  end
  
  def gender_name
    gender.name
  end
  
  def gender_name=(value)
    self.gender = Gender.find_or_create_by_name(value)
  end

  def common_gender_name
    is_common_name(gender_name) ? gender_name : 'other'
  end
  
  def other_gender_name
    is_common_name(gender_name) ? '' : gender_name
  end
  
  def can_be_edited_by?(other_user)
    self == other_user
  end
  
  def self.seperate_users_by_picture(users, maximum = nil)
    with = []
    with_over_max = []
    without = []
    for user in users
      if user.has_avatar?
        if (maximum.nil? || with.length < maximum)
          with << user 
        else
          with_over_max << user
        end
      else
        without << user
      end
    end
    [with, with_over_max + without]
  end
  
  def calculate_permalink_from_nick
    self.permalink = nick.downcase.gsub(/[^a-z0-9]/, '') unless nick.blank?
  end
    
  # Apply SHA1 encryption to the supplied password.
  # We will additionally surround the password with a salt
  # for additional security.
  def self.sha1(pass)
    Digest::SHA1.hexdigest("#{salt}--#{pass}--")
  end
  
  def is_sponsor?
    !sponsorship.nil?
  end
  
  def is_admin?
    is_admin
  end
  
  def can_access_sponsor_features?
    is_sponsor? || is_admin?
  end
  
  def interaction_score_with(other_user)
    return 0 if other_user.nil? || other_user.new_record? || other_user == self
    other_user.interactions_as_subject.count(:conditions => {:actor_id => id})
  end
  
  def can_send_message_to?(other_user)
    can_message_anyone? || (other_user && other_user.can_message_anyone?) || interaction_score_with(other_user) >= 1
  end
  
  def create_profile
    self.profile = Profile.create!(:user => self, :welcome_text => '') unless profile
  end
  
  def all_tags
    profile.interest_tags + profile.kink_tags if profile
  end
  
  def disabled?
    profile && profile.disabled?
  end
  
  def relationships_by_name
    results = []
    for relationship_type in relationship_types.map
      relationships = relationships_for_name(relationship_type)
      results << [relationship_type, relationships] if relationships && !relationships.empty?
    end
    results
  end
  
  def relationships_for_name(relationship_type)
    relationships.select do |relationship|
      relationship.relationship_type == relationship_type
    end
  end
  
  def relationship_with(other_user)
    relationships.find(:first, :conditions => {:subject_id => other_user.id}) if other_user
  end
  
  def select_box_name
    result = name
    result += ' (admin)' if is_admin?
    result
  end
  
  def crush_on(other_user)
    return nil unless other_user && !other_user.new_record?
    crushes.find_by_subject_id(other_user.id)
  end
  
  def current_dare_challenge_with(other_user)
    DareChallenge.find_current_challenge_between(self, other_user)
  end
  
  def to_param
    "#{id}-#{permalink}"
  end
  
  def default_photo_set
    profile.default_photo_set
  end
  
  def on_login
    if !last_logged_in_at || last_logged_in_at < 10.minutes.ago
      update_attribute(:last_logged_in_at, Time.now)
    end
  end
  
protected

  def is_common_name(value)
    ['male', 'female', 'unspecified'].include?(value.to_s.downcase)
  end

  def validate_password?
    self.password != nil && not_dummy?
  end  
  
  def crypt_password
    if !password.blank?
      self.hashed_password = self.class.sha1(password)
      password = nil
    end
  end
  
  def ensure_nick_has_no_underscores
    unless nick.blank? || allow_dummy
      if nick =~ /_/
        errors.add :nick, "shouldn't contain underscores. You're allowed to have spaces and capitals, so why not make it something actually pronounceable."
      end
    end
  end
  
  def not_dummy?
    !dummy?
  end
  
  def validate_permalink?
    not_dummy? && !nick.blank?
  end
  
  def can_message_anyone?
    is_admin? || is_review_manager?
  end
  
  def ensure_email_address_is_valid
    if primary_email_address 
      errors.add(:email, primary_email_address.errors.on(:address)) unless primary_email_address.valid?
    else
      errors.add(:email, "can't be blank")
    end
  end
  
end
