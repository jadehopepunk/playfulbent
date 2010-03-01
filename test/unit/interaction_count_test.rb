# == Schema Information
#
# Table name: interaction_counts
#
#  id         :integer(4)      not null, primary key
#  actor_id   :integer(4)
#  subject_id :integer(4)
#  number     :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class InteractionCountTest < Test::Unit::TestCase
  fixtures :interaction_counts

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
