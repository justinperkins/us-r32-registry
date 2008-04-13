require_dependency "login_system"

class ApplicationController < ActionController::Base
  include LoginSystem
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_usr32registry.org_session_id'
  
  before_filter [ :prepare_user_session_from_last_visit, :clear_out_old_sessions ]
  
  private
  def clear_out_old_sessions
    sessions = CGI::Session::ActiveRecordStore::Session
    sessions.destroy_all(['updated_at < ?', 20.minutes.ago])
  end
  
  def user_to_session(user)
    user = User.find_by_id(user) unless user.is_a? User
    if user
      session[:user_id] = user.id
      user
    else
      nil
    end
  end
  
  def user_hash_to_session(user_hash)
    user = User.find_by_secret_hash(user_hash)
    user_to_session(user) if user
  end
  
  def correct_case chassis
    chassis.upcase.gsub('K', 'k')
  end

  def abbreviated_color color
    color.downcase == 'custom' ? 'Custom' : color.upcase
  end

  def r32_to_s r32
    "#{abbreviated_color @r32.color} #{correct_case @r32.chassis} R32, Owner: #{@r32.owner}"
  end

  def author_is_viewing?
    @user && @r32 && @r32.user == @user
  end

  alias owner_is_viewing? author_is_viewing?
end
