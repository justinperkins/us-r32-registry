class Post < ActiveRecord::Base
  belongs_to :r32
  
  validates_presence_of [:title, :content], :message => 'Required.'
end