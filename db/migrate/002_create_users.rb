# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column "first_name", :string, :limit => 50
      t.column "last_name", :string, :limit => 50
      t.column "email", :string, :limit => 255
      t.column "password", :string, :limit => 255
      t.column "city", :string, :limit => 255
      t.column "state", :string, :limit => 2
      t.column "vortex_id", :string, :limit => 255
      t.column "website", :string, :limit => 255
      
      t.column "created_at", :date
      t.column "updated_at", :date
    end
  end

  def self.down
    drop_table :users
  end
end
