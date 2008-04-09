require 'digest/sha1'

class Confirmation < ActiveRecord::Base
  
  validates_presence_of :related_url, :user_id
  
  belongs_to :user
  
  before_create do |c|
    c.number = Digest::SHA1.hexdigest( Time.now.to_s )
  end
  
  def expired?
    self.created_at > 1.day.from_now
  end
end
