# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class CreateR32s < ActiveRecord::Migration
  def self.up
    create_table :r32s do |t|
      t.column "user_id", :integer, :limit => 10

      t.column "chassis", :string, :limit => 5
      # mkV gets an edition number
      t.column "edition_number", :integer, :limit => 4
      t.column "year", :integer, :limit => 4
      t.column "interior", :string, :limit => 50
      t.column "color", :string, :limit => 50
      t.column "vin", :string, :limit => 255

      t.column "picture", :string, :limit => 255
      t.column "purchased_on", :date
      t.column "preordered", :boolean, :default => false
      t.column "for_sale", :boolean, :default => false
      t.column "notes", :string
      t.column "mods", :string

      t.column "created_at", :date
      t.column "updated_at", :date
    end
  end

  def self.down
    drop_table :r32s
  end
end
