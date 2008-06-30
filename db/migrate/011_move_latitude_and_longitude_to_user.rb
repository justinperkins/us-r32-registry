# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class MoveLatitudeAndLongitudeToUser < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      remove_column :r32s, :latitude
      remove_column :r32s, :longitude

      add_column :users, :latitude, :string
      add_column :users, :longitude, :string
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      add_column :r32s, :latitude, :string
      add_column :r32s, :longitude, :string

      remove_column :users, :latitude
      remove_column :users, :longitude
    end
  end
end
