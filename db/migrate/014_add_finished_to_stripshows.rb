class AddFinishedToStripshows < ActiveRecord::Migration
  def self.up
    add_column(:strip_shows, :finished, :boolean, :default => 0)
  end

  def self.down
    remove_column(:strip_shows, :finished)
  end
end
