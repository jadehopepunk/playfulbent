class AddLastFetchedAtToPhotoSets < ActiveRecord::Migration
  def self.up
    add_column :photo_sets, :last_fetched_at, :datetime, :default => nil
  end

  def self.down
    remove_column :photo_sets, :last_fetched_at
  end
end
