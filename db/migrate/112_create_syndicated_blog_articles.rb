class CreateSyndicatedBlogArticles < ActiveRecord::Migration
  def self.up
    create_table :syndicated_blog_articles do |t|
      t.column :title, :text
      t.column :description, :text
      t.column :published_at, :datetime
      t.column :author, :text
      t.column :link, :text
      t.column :syndicated_blog_id, :integer
    end
  end

  def self.down
    drop_table :syndicated_blog_articles
  end
end
