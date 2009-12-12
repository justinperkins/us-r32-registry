class AddStateFlagToR32s < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      # this column will replace these other three, add it first then copy the data over
      add_column :r32s, :state, :string, :limit => 255

      R32.reset_column_information
      R32.find(:all).each do |r32|
        if r32.preordered
          r32.preordered = true
        elsif r32.totaled
          r32.totaled = true
        elsif r32.for_sale
          r32.for_sale = true
        end
        r32.save
      end

      # then finally remove the old columns
      remove_column :r32s, :totaled
      remove_column :r32s, :preordered
      remove_column :r32s, :for_sale
    end
  end

  def self.down
    add_column :r32s, :totaled, :boolean, :default => false
    add_column :r32s, :preordered, :boolean, :default => false
    add_column :r32s, :for_sale, :boolean, :default => false
    remove_column :r32s, :state
  end
end
