require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  self.use_instantiated_fixtures  = true
  
  fixtures :users
  
  def test_truth
    assert true
  end
end
