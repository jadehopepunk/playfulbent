class AddIsReviewManagerToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_review_manager, :boolean, :default => false
  end

  def self.down
    remove_column :users, :is_review_manager
  end
end
