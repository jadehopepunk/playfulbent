class AddContentToSyndicatedBlogArticles < ActiveRecord::Migration
  def self.up
    add_column :syndicated_blog_articles, :content, :text
  end

  def self.down
    remove_column :syndicated_blog_articles, :content
  end
end
