class DefaultProfilesToUnpublished < ActiveRecord::Migration
  def self.up
    change_column :profiles, :published, :boolean, :default => false
  end

  def self.down
    change_column :profiles, :published, :boolean, :default => true
  end
end
