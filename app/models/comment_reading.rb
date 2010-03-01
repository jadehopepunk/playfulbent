# == Schema Information
#
# Table name: comment_readings
#
#  id         :integer(4)      not null, primary key
#  comment_id :integer(4)
#  user_id    :integer(4)
#  created_on :datetime
#

class CommentReading < ActiveRecord::Base
  belongs_to :comment
  belongs_to :user
  validates_presence_of :comment_id, :user_id
  validates_uniqueness_of :user_id, :scope => :comment_id
end
