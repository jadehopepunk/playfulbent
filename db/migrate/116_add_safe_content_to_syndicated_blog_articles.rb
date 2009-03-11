class AddSafeContentToSyndicatedBlogArticles < ActiveRecord::Migration
  def self.up
    add_column :syndicated_blog_articles, :raw_content, :text
    execute "UPDATE syndicated_blog_articles SET raw_content = content"
    execute "UPDATE syndicated_blog_articles SET content = null"
  end

  def self.down
    execute "UPDATE syndicated_blog_articles SET content = raw_content"
    remove_column :syndicated_blog_articles, :raw_content
  end
end
