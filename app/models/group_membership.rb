# == Schema Information
# Schema version: 258
#
# Table name: group_memberships
#
#  id               :integer(11)   not null, primary key
#  group_id         :integer(11)   
#  yahoo_profile_id :integer(11)   
#  created_at       :datetime      
#  updated_at       :datetime      
#  scraped_at       :datetime      
#

class GroupMembership < ActiveRecord::Base
  belongs_to :yahoo_profile
  belongs_to :group
  
  validates_presence_of :group
  validate :check_if_user_has_group_access
  
  attr_accessor :password
  attr_writer :username

  def self.fetch_for(group, params)
    raise ArgumentError, "GroupMembership.fetch_for requires a group" unless group
    params = {} if params.nil?
    existing_membership(group, params[:username]) || GroupMembership.new(:group => group, :username => params[:username], :password => params[:password])
  end
  
  def user
    yahoo_profile.user if yahoo_profile
  end
  
  def username
    return yahoo_profile.identifier if yahoo_profile
    @username
  end
  
  def group_name
    group.group_name if group
  end
    
  protected
  
    def check_if_user_has_group_access
      self.fetch_for_login_details unless yahoo_profile
      errors.add(:yahoo_profile, "can't be blank") unless yahoo_profile
      true
    end

    def fetch_for_login_details
      errors.add(:username, "can't be blank") if username.blank?
      errors.add(:password, "can't be blank") if password.blank?
      
      if user_belongs_to_group?
        self.yahoo_profile = GroupMembership.existing_profile(username) || YahooProfile.new(:identifier => username)
      end
    end

    def user_belongs_to_group?
      return false if username.blank? || password.blank?
      unless scraper.user_belongs_to_group?(username, password, group_name)
        errors.add_to_base "Sorry, you don't seem to be a member of this group on yahoo.<br /></br />Join the yahoo group first, then try again."
        return false
      end
      true
    end

    def self.existing_membership(group, username)
      profile = existing_profile(username)
      membership = find(:first, :conditions => {:group_id => group.id, :yahoo_profile_id => profile.id}) if profile
    end

    def self.existing_profile(username)
      YahooProfile.find_by_identifier(username) unless username.blank?
    end

    def scraper
      Yahoo::Scraper.new(AppConfig.yahoo_scraper_account)
    end

end
