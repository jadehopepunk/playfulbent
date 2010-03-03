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
#  state        :string(255)     default("open")
#

require File.dirname(__FILE__) + '/../spec_helper'

describe DareGame do
  describe "when creating" do
    before :each do
      @dare_game = Factory.build(:dare_game)
    end
    
    it "should add creator to players" do
      @dare_game.save!
      @dare_game.users.should include(@dare_game.creator)      
    end
  end
end
