ENV["RAILS_ENV"] = "test" 
require File.expand_path(File.dirname(__FILE__) + "/../config/environment") 
require 'application' 
require 'test/unit' 
require 'action_controller/test_process' 
require 'test_help'
require 'rubygems'
require 'mocha'
require 'stubba'

class UnitTest
  def self.TestCase
    class << ActiveRecord::Base
      def connection
        raise InvalidActionError, 'You cannot access the database from a unit test', caller
      end
    end
    Test::Unit::TestCase
    
  end
end

class InvalidActionError < StandardError
end

class Test::Unit::TestCase
  include AuthenticatedTestHelper

  def assert_required_login
    assert_redirected_to :controller => 'users', :action => 'login_or_signup'
  end

  def assert_permission_denied
    assert_response 401
  end
  
end