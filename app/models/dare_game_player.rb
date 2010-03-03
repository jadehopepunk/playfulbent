# == Schema Information
#
# Table name: dare_game_players
#
#  id           :integer(4)      not null, primary key
#  dare_game_id :integer(4)
#  user_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class DareGamePlayer < ActiveRecord::Base
  belongs_to :dare_game
  belongs_to :user
end
