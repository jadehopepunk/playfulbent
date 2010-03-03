# == Schema Information
#
# Table name: dare_games
#
#  id           :integer(4)      not null, primary key
#  creator_id   :integer(4)
#  max_players  :integer(4)
#  name         :string(255)
#  instructions :text
#  created_at   :datetime
#  updated_at   :datetime
#

class DareGame < ActiveRecord::Base
  PLAYER_LIMIT = 10  
  belongs_to :creator, :class_name => "User"
  validates_presence_of :creator, :name
  
  def players
    [creator]
  end
  
  def state
    'open'
  end
  
end
