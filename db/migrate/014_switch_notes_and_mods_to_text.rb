class SwitchNotesAndModsToText < ActiveRecord::Migration
  def self.up
    change_column :r32s, :mods, :text
    change_column :r32s, :notes, :text
  end
  
  def self.down
    change_column :r32s, :mods, :string
    change_column :r32s, :notes, :string
  end
end