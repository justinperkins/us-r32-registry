# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class R32 < ActiveRecord::Base
=begin
  t.column "user_id", :integer, :limit => 10

  t.column "chassis", :string, :limit => 5
  # mkV gets an edition number
  t.column "edition_number", :integer, :limit => 4
  t.column "year", :integer, :limit => 4
  t.column "interior", :string, :limit => 50
  t.column "color", :string, :limit => 50
  t.column "vin", :string, :limit => 255

  t.column "picture_upload", :string, :limit => 255
  t.column "picture_url", :string, :limit => 255
  t.column "purchased_on", :date
  t.column "preordered", :boolean, :default => false
  t.column "for_sale", :boolean, :default => false
  t.column "notes", :string
  t.column "mods", :string
=end

  validates_presence_of [ :chassis, :interior, :color ], :message => 'Required'
  validates_presence_of [ :edition_number ], :if => lambda { |r32| r32.chassis == 'mkv' && !r32.preordered }, :message => 'Required'
  validates_presence_of [ :vin, :purchased_on ], :if => lambda { |r32| !r32.preordered }, :message => 'Required'
  validates_length_of [ :vin ], :is => 17, :if => lambda { |r32| !r32.vin.blank? }, :message => 'Not a vin'
  validates_uniqueness_of [ :vin ], :if => lambda { |r32| !r32.preordered }, :message => 'Already registered!'
  validates_uniqueness_of [ :edition_number ], :if => lambda { |r32| r32.chassis == 'mkv' && !r32.preordered && !r32.edition_number.blank? }, :message => 'Already registered, use VIN to claim'
  validates_format_of [ :picture_url ], :with => /^http:\/\//, :if => lambda { |r32| !r32.picture_url.blank? }, :message => 'Must begin with http://'
  validate :purchased_on_is_valid

  has_many :posts, :order => 'created_at desc'
  belongs_to :user

  def mkiv?
    self.chassis == 'mkiv'
  end
  
  def mkv?
    self.chassis == 'mkv'
  end
  
  def has_posts?
    self.posts.count > 0
  end
  
  def owner
    "#{self.user.first_name} #{self.user.last_name}"
  end
  
  def user_can_alter_this( user = nil )
    user ? user.is_admin? || self.user.id == user.id : false
  end
  
  def year_first_sold
    case self.chassis
    when 'mkiv' then 2003
    when 'mkv' then 2007
    end
  end
  
  class << self
    def active_logs
      find(:all, :conditions => "posts.id IS NOT NULL", :include => :posts, :order => "posts.created_at desc")
    end
    
    def chassis_has_edition_number( chassis )
      chassis == 'mkv'
    end
    
    def find_all_with_latitude_and_longitude( chassis = nil )
      @r32s = ( chassis ? R32.find( :all, :conditions => [ 'chassis = ?', chassis ], :include => 'user' ) : R32.find( :all, :include => 'user' ) )
      @r32s.reject { |r| r.user.latitude.blank? || r.user.longitude.blank? }
    end
    
    def filter_by_chassis chassis, collection
      collection = collection.collect { |r| r.chassis == chassis ? r : nil }
      collection.compact!
      collection
    end
    
    def find_all_candadians
      R32.find(:all, :conditions => ['users.state in (?)', User.canadian_provinces], :include => 'user')
    end
    
    def color_stats_for_chassis chassis, collection
      stats = {}
      collection = collection.collect { |r| r.chassis == chassis ? r : nil }
      collection.compact!
      collection_by_color = collection.group_by(&:color)
      possible_colors( chassis.to_sym => true ).each do |c|
        stats[c[1].to_s] = (collection_by_color[c[1].to_s] ? collection_by_color[c[1].to_s].size : 0)
      end
      [ stats, collection ]
    end

    def possible_chassis
      [
        %w{ MkIV mkiv },
        %w{ MkV mkv }
      ]
    end

    def friendly_color color
      colors = {
        :dbp => 'Deep Blue Pearl',
        :bmp => 'Black Metallic Pearl',
        :rs => 'Reflex Silver',
        :tr => 'Tornado Red',
        :cw => 'Candy White',
        :ug => 'United Gray'
      }

      colors[color.to_sym] || 'Custom'
    end

    def possible_colors(chassis)
      if chassis[:mkiv]
        [
          [ 'Deep Blue Pearl', 'dbp' ],
          [ 'Black Metallic Pearl', 'bmp' ],
          [ 'Reflex Silver', 'rs' ],
          [ 'Tornado Red', 'tr' ],
          [ 'Custom', 'custom' ]
        ]
      elsif chassis[:mkv]
        [
          [ 'Deep Blue Pearl', 'dbp' ],
          [ 'United Grey', 'ug' ],
          [ 'Candy White', 'cw' ],
          [ 'Tornado Red', 'tr' ],
          [ 'Custom', 'custom' ]
        ]
      end
    end

    def possible_interiors(chassis)
      if chassis[:mkiv]
        [
          [ 'Leather', 'leather' ],
          [ 'Cloth', 'cloth' ],
          [ 'Custom', 'custom' ]
        ]
      elsif chassis[:mkv]
        [
          [ 'Leather', 'leather' ],
          [ 'Custom', 'custom' ]
        ]
      end
    end
  end

  def has_url_picture?
    self.picture_url.blank? ? false : true
  end
  
  def image
    if has_url_picture?
      self.picture_url
    else
      "#{self.chassis}/#{self.color}.jpg"
    end
  end
  
  def to_js_r32
    { 
      :id => self.id,
      :mileage => self.mileage || 0,
      :edition_number => ( self.edition_number ? self.edition_number : nil ),
      :chassis => self.chassis, 
      :color => self.color, 
      :interior => self.interior, 
      :city => self.user.city, 
      :state => self.user.state, 
      :purchasedOn => ( self.purchased_on ? self.purchased_on.strftime( '%m/%d/%Y' ) : nil ), 
      :preordered => self.preordered, 
      :owner => self.owner, 
      :ownerID => self.user.id, 
      :latitude => self.user.latitude.to_f, 
      :longitude => self.user.longitude.to_f
    }
  end
  
  protected
  def purchased_on_is_valid
    begin
      errors.add( :purchased_on, 'Invalid date' ) if self.purchased_on.year < self.year_first_sold
    rescue
      errors.add( :purchased_on, 'Not a date' )
    end unless self.purchased_on.blank?
  end
end