require File.dirname(__FILE__) + '/../test_helper'

class RelationshipTypeTest < Test::Unit::TestCase
  fixtures :relationship_types, :users, :email_addresses, :relationships

  def test_truth
    assert true
  end


end
