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
