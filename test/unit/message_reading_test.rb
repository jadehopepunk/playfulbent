# == Schema Information
#
# Table name: message_readings
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  message_id :integer(4)
#  created_at :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class MessageReadingTest < Test::Unit::TestCase
  fixtures :message_readings

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
