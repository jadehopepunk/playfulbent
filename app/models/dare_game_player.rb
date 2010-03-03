class DareGamePlayer < ActiveRecord::Base
  belongs_to :dare_game
  belongs_to :user
end
