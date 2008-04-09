ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true

  self.use_instantiated_fixtures  = false

  def login_to_site user
    controller, response = @controller, @response
    @controller = AccountController.new
    @response   = ActionController::TestResponse.new

    post :login, {:user => {:email => user.email, :password => "test"}}
    
    @controller, @response = controller, response
  end
  
  def login_to_site_as_administrator
    controller, response = @controller, @response
    @controller = AccountController.new
    @response   = ActionController::TestResponse.new

    user = users(:admin)
    post :login, {:user => {:email => user.email, :password => "test"}}
    
    @controller, @response = controller, response
  end
end
