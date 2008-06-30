# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class Post < ActiveRecord::Base
  belongs_to :r32
  
  validates_presence_of [:title, :content], :message => 'Required.'
end