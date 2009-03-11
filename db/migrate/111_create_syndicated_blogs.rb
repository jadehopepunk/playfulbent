class CreateSyndicatedBlogs < ActiveRecord::Migration
  def self.up
    create_table :syndicated_blogs do |t|
      t.column :title, :string
      t.column :feed_url, :string
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :syndicated_blogs
  end
end
