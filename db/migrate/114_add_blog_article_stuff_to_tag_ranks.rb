class AddBlogArticleStuffToTagRanks < ActiveRecord::Migration
  def self.up
    add_column :tag_ranks, :blog_article_count, :integer, :default => 0
    add_column :tag_ranks, :blog_article_ratio, :integer, :default => 0
  end

  def self.down
    remove_column :tag_ranks, :blog_article_count
    remove_column :tag_ranks, :blog_article_ratio
  end
end
