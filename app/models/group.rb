# == Schema Information
# Schema version: 258
#
# Table name: groups
#
#  id                        :integer(11)   not null, primary key
#  owner_id                  :integer(11)   
#  group_name                :string(255)   
#  name                      :string(255)   
#  description               :text          
#  created_at                :datetime      
#  updated_at                :datetime      
#  archive_access_level      :string(255)   
#  scraped_at                :datetime      
#  members_list_access_level :string(255)   
#  external_member_count     :integer(11)   
#  map_lat                   :float         
#  map_long                  :float         
#  map_zoom                  :integer(11)   
#

class Group < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User', :foreign_key => :owner_id
  has_many :mailing_list_messages
  has_many :group_memberships, :dependent => :destroy
  has_many :yahoo_profiles, :through => :group_memberships
  has_many :root_list_messages, :class_name => 'MailingListMessage', :conditions => {:parent_id => nil}, :order => 'received_at DESC'
  acts_as_group
  
  validates_presence_of :owner, :group_name, :name
  validates_uniqueness_of :group_name
  
  attr_protected :owner, :owner_id
  
  before_validation_on_create :fetch_group_data
  
  ACCESS_OFF = 'off'
  ACCESS_MEMBERS_ONLY = 'members'
  ACCESS_ANYONE = 'anyone'
  ACCESS_LEVELS = [ACCESS_OFF, ACCESS_MEMBERS_ONLY, ACCESS_ANYONE]
  
  def self.find_by_param(param)
    Group.find_by_group_name(param) || raise(ActiveRecord::RecordNotFound)
  end
  
  def to_param
    group_name
  end
  
  def display_name
    name.blank? || name.length >= 100 ? group_name : name
  end
  
  def subscribe_to_list    
    raise NotImplementedError
  end
  
  def mailing_list_can_be_read_by?(reading_user)
    user_meets_access?(reading_user, archive_access_level)
  end
  
  def members_list_can_be_read_by?(reading_user)
    comparison_level = (members_list_access_level == ACCESS_ANYONE ? ACCESS_ANYONE : ACCESS_MEMBERS_ONLY)
    user_meets_access?(reading_user, comparison_level)
  end
  
  def make_member(external_profile)
    raise ArgumentError if external_profile.nil?
    unless is_external_member?(external_profile)
      group_memberships.build(:yahoo_profile => external_profile).save!
    end
  end

  def is_internal_member?(internal_user)
    return false unless internal_user
    
    for profile in internal_user.yahoo_profiles
      return true if is_external_member?(profile)
    end
    false
  end

  def is_external_member?(external_profile)
    external_profile && group_memberships.find(:first, :conditions => {:yahoo_profile_id => external_profile.id})
  end
  
  def user_count
    yahoo_profiles.count("user_id IS NOT NULL")
  end
    
  protected
  
    def user_meets_access?(reading_user, access_level)
      access_level == ACCESS_ANYONE || (access_level == ACCESS_MEMBERS_ONLY && is_internal_member?(reading_user))
    end
    
end
