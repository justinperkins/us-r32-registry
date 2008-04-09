require File.dirname(__FILE__) + '/../test_helper'
require 'account_controller'

# Raise errors beyond the default web-based presentation
class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < Test::Unit::TestCase
  fixtures :users
  
  def setup
    @controller = AccountController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
  end
  
  def test_show
    user = users(:normal)
    get :show, :id => user.id
    assert_response :success
    assert_select 'fieldset p', /#{user.display_name}/
    assert_select 'fieldset p.email script'
    assert_select 'fieldset p', /#{user.city}, #{user.state}/
    assert_select 'fieldset p', /#{user.city}, #{user.state}/
    assert_select 'fieldset p', /#{user.vortex_id}/
    assert_select 'fieldset p', /#{user.website}/
    assert_select 'fieldset p', :text => /Edit your profile/, :count => 0
  end
  
  def test_logged_in_can_edit_their_profile
    user = users(:normal)
    login_to_site user
    get :show, :id => user.id
    assert_response :success
    assert_select 'fieldset p', :text => /Edit your profile/
  end

  def test_login
    user = users(:normal)
    post :login, :user => { :email => user.email, :password => 'test' }
    assert_redirected_to '/'
  end
end
