class AddUserHashToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :secret_hash, :string, :limit => 255
    User.find(:all).each do |user|
      puts "Saving #{ user.id } with hash"
      user.build_secret_hash
      puts "Hash is: #{ user.secret_hash }"
      user.save
    end
  end

  def self.down
    remove_column :users, :secret_hash
  end
end
