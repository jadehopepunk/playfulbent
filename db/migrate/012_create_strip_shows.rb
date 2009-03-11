class CreateStripShows < ActiveRecord::Migration
  def self.up
      create_table :strip_shows do |table|
        table.column(:user_id,  :integer)
      end
  end

  def self.down
      drop_table :strip_shows
  end
end
