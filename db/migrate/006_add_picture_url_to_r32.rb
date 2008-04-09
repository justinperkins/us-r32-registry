class AddPictureUrlToR32 < ActiveRecord::Migration
  def self.up
    add_column :r32s, :picture_url, :string
    add_column :r32s, :picture_upload, :string
    add_column :r32s, :uploaded_picture_name, :string
    remove_column :r32s, :picture
  end

  def self.down
    remove_column :r32s, :picture_url
    remove_column :r32s, :picture_upload
    remove_column :r32s, :uploaded_picture_name
    add_column :r32s, :picture, :string
  end
end
