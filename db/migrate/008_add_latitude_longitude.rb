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
