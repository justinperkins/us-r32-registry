# Copyright © 2006-07 Spiceworks, Inc.  All Rights Reserved.  http://www.spiceworks.com
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