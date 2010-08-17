class AddContributorLevel < ActiveRecord::Migration
  def self.up
    add_column :users, :contributor_level, :string, :limit => 255
  end

  def self.down
    remove_column :users, :contributor_level
  end
end
