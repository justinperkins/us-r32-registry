require_dependency "user"

module LoginSystem 
  
  protected
  
  # overwrite this if you want to restrict access to only a few actions
  # or if you want to check if the user has the correct rights  
  # example:
  #
  #  # only allow nonbobs
  #  def authorize?(user)
  #    user.login != "bob"
  #  end
  def authorize?(user)
     true
  end
  
  # overwrite this method if you only want to protect certain actions of the controller
  # example:
  # 
  #  # don't protect the login and the about method
  #  def protect?(action)
  #    if ['action', 'about'].include?(action)
  #       return false
  #    else
  #       return true
  #    end
  #  end
  def protect?(action)
    true
  end
   
  # login_required filter. add 
  #
  #   before_filter :login_required
  #
  # if the controller should be under any rights management. 
  # for finer access control you can overwrite
  #   
  #   def authorize?(user)
  # 
  def login_required

    return true if not protect?(action_name)

    return true if session[:user_id] && authorize?(session[:user_id])

    return true if cookies[:user_id] && authorize?(cookies[:user_id]) && user_to_session(cookies[:user_id])

    # call overwriteable reaction to unauthorized access
    access_denied
    return false 
  end
  
  def prepare_user_session_from_last_visit
    cookies[:user_id] && authorize?(cookies[:user_id]) && user_to_session(cookies[:user_id]) unless session[:user_id]
  end
  
  # overwrite if you want to have special behavior in case the user is not authorized
  # to access the current operation. 
  # the default action is to redirect to the login screen
  # example use :
  # a popup window might just close itself for instance
  def access_denied
    redirect_to :controller=>"/account", :action =>"login"
  end  
end