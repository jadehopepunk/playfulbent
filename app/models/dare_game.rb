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
  has_many :dare_game_players, :dependent => :destroy
  has_many :users, :through => :dare_game_players
  
  validates_presence_of :creator, :name  
  
  before_create :add_creator_to_users
  
  def state
    'open'
  end
  
  def user_is_player?(current_user)
    users.include?(current_user)
  end
  
  def player_limit
    max_players || PLAYER_LIMIT
  end
  
  def player_limit_reached?
    users.count >= player_limit
  end
  
  def add_user(user_to_add)
    self.users << user_to_add if !users.include?(user_to_add) && !player_limit_reached?
  end
  
  private
  
    def add_creator_to_users
      self.users << creator
    end
  
end
