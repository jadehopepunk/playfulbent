class AddReviewTagCounts < ActiveRecord::Migration
  def self.up
    add_column :tag_ranks, :review_count, :integer, :default => 0
    add_column :tag_ranks, :review_ratio, :integer, :default => 0
  end

  def self.down
    remove_column :tag_ranks, :review_count
    remove_column :tag_ranks, :review_ratio
  end
end
