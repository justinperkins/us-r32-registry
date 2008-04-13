require 'digest/sha1'
require 'net/http'

class User < ActiveRecord::Base

  validates_presence_of [:first_name, :last_name, :email, :city, :state], :message => 'required'
  validates_presence_of [:password, :password_confirmation], :message => 'required', :on => :create
  validates_uniqueness_of :email, :on => :create
  validates_confirmation_of :password, :on => :create
  has_many :r32s
  has_many :confirmations
  before_create :crypt_password
  before_save :update_latitude_and_longitude
  after_create :build_secret_hash
  
  def has_r32?
    self.r32s.count > 0
  end
  
  def display_name
    "#{first_name} #{last_name}"
  end

  def self.authenticate(email, pass)
    find :first, :conditions => ["email = ? AND password = ?", email, sha1(pass)]
  end
  
  def self.find_an_admin
    find 1
  end  

  def change_password(attributes)
    if attributes[:password].blank?
      errors.add('password', 'required')
      false
    elsif attributes[:password] != attributes[:password_confirmation]
      errors.add('password_confirmation', 'does not match')
      false
    else
      update_attribute "password", self.class.sha1(attributes[:password])
    end
  end
  
  def user_can_alter_this( user = nil )
    user ? user.is_admin? || user.id == self.id : false
  end
  
  def forgot_password( destination )
    sent_ok = false
    begin
      confirmation = Confirmation.create :related_url => destination, :user => self
      forgot_password = Notifier.deliver_forgot_password self, confirmation
      sent_ok = true
    rescue
      logger.debug "Failed during forgot_password: #{ $! }"
    end
    sent_ok
  end
    
  def build_secret_hash
    self.secret_hash = Digest::SHA1.hexdigest("#{ GLOBAL_SALT }-#{ self.id }")
    return true
  end
  
  protected

  def self.sha1(pass)
    Digest::SHA1.hexdigest("us-r32-registry--#{pass}--")
  end
    
  
  def crypt_password
    write_attribute("password", self.class.sha1(password))
  end
  
  def update_latitude_and_longitude
    
    # reset the lat/long, to cover any failure conditions below
    self.latitude = self.longitude = 0
    
    response = Net::HTTP.get 'maps.google.com', map_coordinate_path
    if response
      response = response.split ','
      if !response.empty? && response[0] == '200'
        self.latitude = response[2]
        self.longitude = response[3]
      end
    end
  end
  
  private
  
  def map_coordinate_path
    "/maps/geo?q=#{ CGI.escape( self.city ) },%20#{ CGI.escape( self.state ) }&output=csv&key=#{ GOOGLE_MAPS_API_KEY }"
  end
end