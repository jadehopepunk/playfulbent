class DareGame < ActiveRecord::Base
  PLAYER_LIMIT = 10  
  belongs_to :creator, :class_name => "User"
  validates_presence_of :creator, :name
  
  def players
    [creator]
  end
  
end