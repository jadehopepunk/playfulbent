# == Schema Information
# Schema version: 258
#
# Table name: fantasy_roles
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   
#  fantasy_id :integer(11)   
#  created_at :datetime      
#  updated_at :datetime      
#

class FantasyRole < ActiveRecord::Base
  FIRST_PERSON_NAME = 'me'
  THIRD_PERSON_FANTASIZER_NAME = 'Protagonist'
  
  belongs_to :fantasy
  has_many :fantasy_actors, :dependent => :destroy
  has_many :actors, :through => :fantasy_actors, :class_name => 'User', :source => :user
  
  class << self    
    def new_first_person(user)
      role = FantasyRole.new(:name => FIRST_PERSON_NAME)
      role.actors << user
      role
    end
  end

  def other_actors(user)
    actors.other_than_user(user)
  end    
  
  def protagonist?
    name == FIRST_PERSON_NAME
  end
  
  def third_person_name
    name == FIRST_PERSON_NAME ? THIRD_PERSON_FANTASIZER_NAME : name
  end
  
  def is_actor?(user)
    actors.include?(user)
  end
  
end
