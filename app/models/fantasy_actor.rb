# == Schema Information
# Schema version: 258
#
# Table name: fantasy_actors
#
#  id              :integer(11)   not null, primary key
#  user_id         :integer(11)   
#  fantasy_role_id :integer(11)   
#  created_at      :datetime      
#  updated_at      :datetime      
#

class FantasyActor < ActiveRecord::Base
  belongs_to :user
  belongs_to :role, :class_name => 'FantasyRole', :foreign_key => :fantasy_role_id
  
  validates_presence_of :role, :user
  validates_uniqueness_of :user_id, :scope => :fantasy_role_id
end
