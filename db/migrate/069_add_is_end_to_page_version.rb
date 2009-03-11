class AddIsEndToPageVersion < ActiveRecord::Migration
  def self.up
    add_column :page_versions, :is_end, :boolean, :default => false
  end

  def self.down
    remove_column :page_versions, :is_end
  end
end
