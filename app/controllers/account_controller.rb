# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class AccountController < ApplicationController
  before_filter :login_required, :only => [ :edit, :change_password ]
  before_filter :set_current_user
  
  def show
    @showing_user = User.find params[:id] rescue redirect_to '/'
  end

  def login
    redirect_to '/' and return if session[:user_id]
    @page_title = 'Please Login'
    case request.method
    when :post
      if user = User.authenticate(params[:user][:email], params[:user][:password])
        remember_user(user)
        flash[:notice]  = "Login successful"
        redirect_to '/'
      else
        @user = User.new :email => params[:user_email]
        flash.now[:notice]  = "Login unsuccessful"
      end
    when :get
      @user = User.new
    end
  end
  
  def logout
    session[:user_id] = nil
    cookies.delete :user_hash
    redirect_to '/'
  end

  def forgot_password
    @page_title = 'Forgot Your Password?'
    @errors = { :email => '' }
    case request.method
    when :post
      unless params[:email].blank?
        @user_that_forgot = User.find_by_email params[:email]
        @errors[:email] = 'not found' unless @user_that_forgot
        @sent_ok = @user_that_forgot.forgot_password url_for( :controller => '/account', :action => 'change_password', :id => @user_that_forgot ) if @user_that_forgot
      else
        @errors[:email] = 'required'
      end
    when :get
    end
  end
  
  def password_recovery
    confirmation = Confirmation.find_by_number params[:id] rescue redirect_to '/' and return
    if confirmation && !confirmation.expired?
      remember_user(confirmation.user)
      @edit_user = confirmation.user
      render :action => 'change_password'
    else
      flash[:notice] = 'Email expired. If you requested your password the email we sent you expires after 1 day.'
      redirect_to :action => 'forgot_password'
    end

  end
  
  def change_password
    @edit_user = User.find params[:id] rescue redirect_to '/'
    
    redirect_to '/' and return unless @edit_user.user_can_alter_this( @user )

    case request.method
    when :post
      if @edit_user.change_password params[:user]
        flash[:notice] = "Password updated" 
        redirect_to :controller => 'account', :action => 'show', :id => @edit_user.id
      end
    when :get
    end
  end

  def create
    @page_title = 'Create Your Account'
    case request.method
      when :post
        @create_user = User.new params[:user]
        
        if @create_user.save
          remember_user(@create_user)
          flash[:notice]  = "Signup successful"
          redirect_to :controller => 'r32s', :action => 'add'
        end
      when :get
        @create_user = User.new
    end      
  end
  
  def edit
    @edit_user = User.find params[:id] rescue redirect_to '/'
    
    redirect_to '/' and return unless @edit_user.user_can_alter_this( @user )

    @page_title = 'Edit Your Account'
    case request.method
    when :post

      user_attributes = params[:user]

      # the edit page does not allow the user to edit their password, there is a special page for that
      user_attributes.delete(:password) && user_attributes.delete(:password_confirmation)

      if @edit_user.update_attributes user_attributes
        flash[:notice] = "Changes saved"
        redirect_to :controller => 'account', :action => 'show', :id => @edit_user.id
      end
    when :get
    end
  end
  
  def check_location
    valid = is_valid_city_state(params[:city], params[:state])
    respond_to do |format|
      format.html { render :text => (valid ? 'valid' : 'invalid') }
      format.js do
        render :update do |page|
          page.replace_html 'account-message', (valid ? 'City/state verified, submitting ...' : 'The city/state you provided could not be mapped. This means you won\'t show up on the R32 map. If that is OK with you, please click the submit button, otherwise please check the location and try again.')
          page.account.location_checked(valid ? true : false)
        end
      end
    end
  end
  
  private
  def is_valid_city_state(city, state)
    return unless city && state
    response = Net::HTTP.get 'maps.google.com', "/maps/geo?q=#{ CGI.escape( city ) },%20#{ CGI.escape( state ) }&output=csv&key=#{ GOOGLE_MAPS_API_KEY }"
    if response
      response = response.split(',')
      return response if !response.empty? && response[0] == '200' && response[2] != '0' && response[3] != '0'
    end
  end
  
  def set_current_user
    @user = User.find session[:user_id] if session[:user_id]
  end
end