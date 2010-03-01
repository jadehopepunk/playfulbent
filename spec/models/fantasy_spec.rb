# == Schema Information
#
# Table name: fantasies
#
#  id          :integer(4)      not null, primary key
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  creator_id  :integer(4)
#

require File.dirname(__FILE__) + '/../spec_helper'

describe Fantasy, "when trying to save" do
  before do
    @creator = model_factory.user
  end
  
  it "should require a first person pronoun" do
    fantasy = Fantasy.new(:creator => @creator, :description => "Sex is good.")
    fantasy.should_not be_valid
    fantasy.errors.on(:description).should include('must include a first person pronoun. Try using a word like "I" or "me"')
  end
  
  it "should have a role for the creator" do
    fantasy = Fantasy.new(:creator => @creator, :description => "I like sex.")
    fantasy.roles.length.should == 1
    role = fantasy.roles.first
    role.name.should == 'me'
    role.actors.length.should == 1
    role.actors.first.should == @creator
  end
  
  it "should have a role for names in brackets" do
    fantasy = Fantasy.new(:creator => @creator, :description => "I like sex with [Dick]")
    fantasy.roles.length.should == 2
    role = fantasy.roles[1]
    role.name.should == 'Dick'
    role.actors.length.should == 0
  end
  
end
