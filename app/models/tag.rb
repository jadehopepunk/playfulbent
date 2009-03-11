# == Schema Information
# Schema version: 258
#
# Table name: tags
#
#  id   :integer(11)   not null, primary key
#  name :string(255)   
#


class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :stories, :through => :taggings, :uniq => true, :conditions => "taggings.taggable_type = 'Story'"
  has_many :profiles, :through => :taggings, :uniq => true, :conditions => "taggings.taggable_type = 'Profile'"
  has_many :dares, :through => :taggings, :uniq => true, :conditions => "taggings.taggable_type = 'Dare'"
  has_many :gallery_photos, :through => :taggings, :uniq => true, :conditions => "taggings.taggable_type = 'GalleryPhoto'"

  validates_presence_of :name
  validates_uniqueness_of :name

  cattr_accessor :destroy_unused
  self.destroy_unused = false
  
  def update_rank
    unless new_record?
      rank = TagRank.find_or_create_by_tag_id(id)
      rank.update_attributes(:profile_count => count_taggings('Profile'), 
        :story_count => count_taggings('Story'), 
        :dare_count => count_taggings('Dare'), 
        :blog_article_count => count_taggings('SyndicatedBlogArticle'),
        :gallery_photo_count => count_taggings('GalleryPhoto'),
        :review_count => count_taggings('Review'),
        :global_count => taggings.count('id', :conditions => "taggable_type != 'SyndicatedBlogArticle'"))
    end
  end
  
  def taggable_conditions(taggable_type_name)
    "(#{taggable_type_name.tableize}.id IN (SELECT taggable_id FROM taggings LEFT JOIN tags ON taggings.tag_id = tags.id WHERE taggings.taggable_type = '#{taggable_type_name}' AND tags.name = #{connection.quote(name)}))"
  end
  
  def self.parse(list)
    tag_names = []

    # first, pull out the quoted tags
    list.gsub!(/\"(.*?)\"\s*/ ) { tag_names << $1; "" }

    # then, replace all commas with a space
    list.gsub!(/,/, " ")

    # then, get whatever's left
    tag_names.concat list.split(/\s/)

    # strip whitespace from the names
    tag_names = tag_names.map { |t| t.strip }

    # delete any blank tag names
    tag_names = tag_names.delete_if { |t| t.empty? }
    
    return tag_names
  end

  def tagged
    @tagged ||= taggings.collect { |tagging| tagging.taggable }
  end
  
  def on(taggable)
    taggings.build :taggable => taggable
  end
  
  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end
  
  def to_s
    name
  end
  
  def to_param
    name.downcase
  end
  
  def self.rank_tags(tags)
    tag_counts = {}
    for tag in tags
      if tag_counts[tag]
        tag_counts[tag] += 1
      else
        tag_counts[tag] = 1
      end
    end
    
    min = tag_counts.values.min
    max = tag_counts.values.max
    
    tag_counts.each do |tag, count| 
      tag_counts[tag] = TagRank.tag_ratio(count, min, max)
    end
    tag_counts
  end
  
  def self.popular_ranked_tags(limit)
    TagRank.find(:all, :limit => limit, :order => 'global_count DESC', :conditions => 'global_count > 0')
  end
  
  # LIKE is used for cross-database case-insensitivity
  def self.find_or_create_with_like_by_name(name)
    find(:first, :conditions => ["name LIKE ?", name]) || create(:name => name)
  end

  def count
    read_attribute(:count).to_i
  end
  
protected

  def count_taggings(taggable_type)
    Tagging.count(:conditions => {:taggable_type => taggable_type, :tag_id => id})
  end

end
