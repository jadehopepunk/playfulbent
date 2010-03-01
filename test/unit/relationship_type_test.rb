# == Schema Information
#
# Table name: relationship_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  user_id    :integer(4)
#  position   :integer(4)
#

require File.dirname(__FILE__) + '/../test_helper'

class RelationshipTypeTest < Test::Unit::TestCase
  fixtures :relationship_types, :users, :email_addresses, :relationships

  def test_truth
    assert true
  end


end
