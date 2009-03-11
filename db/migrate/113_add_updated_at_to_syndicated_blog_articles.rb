class AddUpdatedAtToSyndicatedBlogArticles < ActiveRecord::Migration
  def self.up
    add_column :syndicated_blog_articles, :updated_at, :datetime
  end

  def self.down
    add_column :syndicated_blog_articles, :updated_at
  end
end
