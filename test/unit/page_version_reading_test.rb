# == Schema Information
#
# Table name: page_version_readings
#
#  id              :integer(4)      not null, primary key
#  page_version_id :integer(4)
#  story_id        :integer(4)
#  user_id         :integer(4)
#  created_at      :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class PageVersionReadingTest < Test::Unit::TestCase
  fixtures :page_version_readings

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
