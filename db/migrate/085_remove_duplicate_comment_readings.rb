class RemoveDuplicateCommentReadings < ActiveRecord::Migration
  def self.up
    for comment in Comment.find(:all)
      for user in users_for_comment(comment)
        first_reading = CommentReading.find(:first, :conditions => {:comment_id => comment.id, :user_id => user.id}, :order => "id ASC")
        CommentReading.destroy_all(["comment_id = ? and user_id = ? and id != ?", comment.id, user.id, first_reading.id])
      end
    end
  end

  def self.down
  end
  
private

  def self.users_for_comment(comment)
    CommentReading.find(:all, :conditions => {:comment_id => comment.id}).collect {|reading| reading.user}.uniq
  end
  
end
