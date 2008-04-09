class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.column :r32_id, :string
      t.column :title, :string
      t.column :content, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end

    add_index :posts, :r32_id
  end

  def self.down
    drop_table :posts
  end
end
