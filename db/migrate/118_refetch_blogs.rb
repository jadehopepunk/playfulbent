class RefetchBlogs < ActiveRecord::Migration
  def self.up
    for blog in SyndicatedBlog.find(:all)
      blog.re_fetch_updates
    end
  end

  def self.down
  end
end
