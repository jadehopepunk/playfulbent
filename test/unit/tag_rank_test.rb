# == Schema Information
#
# Table name: tag_ranks
#
#  id                  :integer(4)      not null, primary key
#  tag_id              :integer(4)
#  story_count         :integer(4)      default(0)
#  profile_count       :integer(4)      default(0)
#  created_at          :datetime
#  updated_at          :datetime
#  story_ratio         :integer(4)      default(0)
#  profile_ratio       :integer(4)      default(0)
#  dare_count          :integer(4)      default(0)
#  dare_ratio          :integer(4)      default(0)
#  blog_article_count  :integer(4)      default(0)
#  blog_article_ratio  :integer(4)      default(0)
#  global_ratio        :integer(4)      default(0)
#  global_count        :integer(4)      default(0)
#  gallery_photo_count :integer(4)
#  gallery_photo_ratio :integer(4)
#  review_count        :integer(4)      default(0)
#  review_ratio        :integer(4)      default(0)
#

require File.dirname(__FILE__) + '/../test_helper'

class TagRankTest < Test::Unit::TestCase
  fixtures :tag_ranks

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
