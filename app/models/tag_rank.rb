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

class TagRank < ActiveRecord::Base
  belongs_to :tag
  validates_presence_of :tag_id
  
  RATIO_MAXIMUM = 5
  CLOUD_SIZE = 30
  RATIO_TYPES = [:story, :profile, :dare, :blog_article, :gallery_photo, :review]
  
  def update_ratios    
    for ratio_type in RATIO_TYPES
      self.send("#{ratio_type}_ratio=".to_sym, ratio(ratio_type))
    end
    self.global_ratio = ratio
    save!
  end
  
  def self.tag_ratio(count, min, max)
    return 0 if max == 0 || max.nil?

    adjusted_max = max - min
    adjusted_count = count - min
    
    return 1 if adjusted_max == 0
    
    result = ((adjusted_count.to_f / adjusted_max.to_f) * RATIO_MAXIMUM.to_f).ceil.to_i
    result = 1 if result <= 0
    result
  end
  
  
protected

  def max_for(count_field)
    self.class.maximum(count_field)
  end
  
  def min_for_cloud(count_field)
    results = self.class.find(:all, :order => "#{count_field} DESC", :limit => CLOUD_SIZE)
    results.empty? ? 0 : results.last.send(count_field)
  end

  def ratio(taggable_type = nil)
    count_field = taggable_type ? "#{taggable_type}_count".to_s : 'global_count'
    count = self.send(count_field)
    max = max_for(count_field)
    min = min_for_cloud(count_field)
    
    self.class.tag_ratio(count, min, max)
  end
  
  
end
