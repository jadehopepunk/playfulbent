class AddReviewFields < ActiveRecord::Migration
  def self.up
    add_column :reviews, :sexyness_rating, :integer
    add_column :reviews, :durability_rating, :integer
    add_column :reviews, :cleaning_rating, :integer
    add_column :reviews, :pleasure_rating, :integer
    add_column :reviews, :overall_rating, :integer
    add_column :reviews, :body, :text
  end

  def self.down
    remove_column :reviews, :sexyness_rating
    remove_column :reviews, :durability_rating
    remove_column :reviews, :cleaning_rating
    remove_column :reviews, :pleasure_rating
    remove_column :reviews, :overall_rating
    remove_column :reviews, :body
  end
end
