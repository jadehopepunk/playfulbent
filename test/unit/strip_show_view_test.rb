# == Schema Information
#
# Table name: strip_show_views
#
#  id                  :integer(4)      not null, primary key
#  strip_show_id       :integer(4)
#  user_id             :integer(4)
#  max_position_viewed :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class StripShowViewTest < Test::Unit::TestCase
  fixtures :strip_show_views

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
