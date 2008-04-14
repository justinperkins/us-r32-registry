class AddUserHashToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :secret_hash, :string, :limit => 255
  end

  def self.down
    remove_column :users, :secret_hash
  end
end
