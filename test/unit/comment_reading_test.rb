# == Schema Information
#
# Table name: comment_readings
#
#  id         :integer(4)      not null, primary key
#  comment_id :integer(4)
#  user_id    :integer(4)
#  created_on :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class CommentReadingTest < Test::Unit::TestCase
  fixtures :comment_readings

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
