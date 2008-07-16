# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

require_dependency "login_system"

class ApplicationController < ActionController::Base
  include LoginSystem
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_usr32registry.org_session_id'
  
  before_filter [ :prepare_user_session_from_last_visit, :clear_out_old_sessions ]
  
  # uncomment this before_filter to throw up maintenence mode
  # before_filter :maintenence
  
  private
  def maintenence
    redirect_to '/maintenence.html' unless ['69.148.19.22', 'localhost', '127.0.0.1'].include?(request.env['REMOTE_ADDR'])
  end
  
  def clear_out_old_sessions
    sessions = CGI::Session::ActiveRecordStore::Session
    sessions.destroy_all(['updated_at < ?', 20.minutes.ago])
  end
  
  def remember_user(user)
    cookies[:user_hash] = {:value => user.secret_hash, :expires => 1.year.from_now}
    user_to_session user
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
    remember_user(user) if user
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
