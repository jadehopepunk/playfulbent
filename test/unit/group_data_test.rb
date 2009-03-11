require File.dirname(__FILE__) + '/../unit_test_helper'

# require 'test/unit'
# require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))
# require RAILS_ROOT + '/vendor/plugins/acts_as_group/lib/group_data'

class GroupDataTest < Test::Unit::TestCase
  
  def test_html_name_converts_html_entities
    data = GroupData.new
    data.html_name = "&lt; stuff"
    assert_equal '< stuff', data.name
  end
  
end
