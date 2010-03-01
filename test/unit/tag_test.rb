# == Schema Information
#
# Table name: tags
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

require File.dirname(__FILE__) + '/../test_helper'

class TagTest < Test::Unit::TestCase
  fixtures :tags, :taggings
  
  def test_update_rank
    tag = tags(:fluffy)
    rank = TagRank.new
    
    TagRank.expects(:find_or_create_by_tag_id).with(tag.id).returns(rank)
    rank.expects(:update_attributes).with(:review_count => 0, :blog_article_count => 0, :gallery_photo_count => 0, :profile_count => 4, :global_count => 7, :story_count => 3, :dare_count => 0)
    
    tag.update_rank
  end
end
