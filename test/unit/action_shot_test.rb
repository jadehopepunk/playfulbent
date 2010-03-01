# == Schema Information
#
# Table name: action_shots
#
#  id           :integer(4)      not null, primary key
#  parent_id    :integer(4)
#  content_type :string(255)
#  filename     :string(255)
#  thumbnail    :string(255)
#  size         :integer(4)
#  width        :integer(4)
#  height       :integer(4)
#  review_id    :integer(4)
#  title        :string(255)
#

require File.dirname(__FILE__) + '/../test_helper'

class ActionShotTest < Test::Unit::TestCase
  fixtures :action_shots

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
