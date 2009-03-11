class CreateActivitiesForReviews < ActiveRecord::Migration
  def self.up
    for review in Review.find(:all)
      activity = ActivityCreatedReview.create_for(review)
      activity.update_attribute(:created_at, review.created_at)      
    end
  end

  def self.down
  end
end
