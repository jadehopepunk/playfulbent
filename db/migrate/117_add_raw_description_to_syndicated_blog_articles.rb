class AddRawDescriptionToSyndicatedBlogArticles < ActiveRecord::Migration
  def self.up
    add_column :syndicated_blog_articles, :raw_description, :text
    execute "UPDATE syndicated_blog_articles SET raw_description = description"
  end

  def self.down
    execute "UPDATE syndicated_blog_articles SET description = raw_description"
    remove_column :syndicated_blog_articles, :raw_description
  end
end
