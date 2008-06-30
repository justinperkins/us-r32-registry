# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class Initial < ActiveRecord::Migration

  def self.up
        
    ActiveRecord::Schema.define() do
      begin
        create_table "schema_info", :force => false do |t|
          t.column "version", :integer, :id => false
        end
      rescue Exception => e
        # Do nothing the db table already exists
      end
    end
  end

  def self.down
  end
end