# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class AddMileageAndTotaledToR32s < ActiveRecord::Migration
  def self.up
    add_column :r32s, :totaled, :boolean, :default => false
    add_column :r32s, :mileage, :integer, :limit => 10
  end

  def self.down
    remove_column :r32s, :totaled
    remove_column :r32s, :mileage
  end
end
