# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class CreateConfirmations < ActiveRecord::Migration
  def self.up
    create_table :confirmations do |t|
      t.column 'related_url', :string, :limit => 255
      t.column 'user_id', :integer, :limit => 10
      t.column 'number', :string, :limit => 255
      t.column 'created_at', :datetime
    end
  end

  def self.down
    drop_table :confirmations
  end
end
