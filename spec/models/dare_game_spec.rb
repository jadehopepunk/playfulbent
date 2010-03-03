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
