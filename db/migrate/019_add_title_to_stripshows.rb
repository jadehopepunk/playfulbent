class AddTitleToStripshows < ActiveRecord::Migration
  def self.up
    add_column :strip_shows, :title, :string
  end

  def self.down
    remove_colum :strip_shows, :title
  end
end
