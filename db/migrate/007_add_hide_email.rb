# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class AddHideEmail < ActiveRecord::Migration
  def self.up
    add_column :users, :hide_email, :boolean
  end

  def self.down
    remove_column :users, :hide_email
  end
end
