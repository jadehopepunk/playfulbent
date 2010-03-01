# == Schema Information
#
# Table name: relationship_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  user_id    :integer(4)
#  position   :integer(4)
#

class RelationshipType < ActiveRecord::Base
  has_many :relationships
  
  acts_as_list :scope => :user_id

  validates_length_of :name, :maximum => 255
  validates_uniqueness_of :name, :scope => :user_id
  
  def self.find_or_initialize_by_name_and_user_id(name, user_id)
    RelationshipType.find(:first, :conditions => {:name => name, :user_id => user_id}) || RelationshipType.new(:name => name, :user_id => user_id)
  end
  
  def is_reciprocated?
    for relationship in relationships
      return false unless relationship.is_reciprocated?
    end
    true
  end
  
end
