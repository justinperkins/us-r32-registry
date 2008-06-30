# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class AddLatitudeLongitude < ActiveRecord::Migration
  def self.up
    add_column :r32s, :latitude, :string
    add_column :r32s, :longitude, :string
  end

  def self.down
    remove_column :r32s, :latitude
    remove_column :r32s, :longitude
  end
end
