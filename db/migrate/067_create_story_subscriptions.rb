class CreateStorySubscriptions < ActiveRecord::Migration
  def self.up
    create_table :story_subscriptions do |t|
      t.column :story_id, :integer
      t.column :user_id, :integer
      t.column :continue_page_i_wrote, :boolean, :default => true
      t.column :continue_page_i_follow, :boolean, :default => false
    end
    
    add_index :story_subscriptions, [:story_id, :user_id], :unique => true
  end

  def self.down
    drop_table :story_subscriptions
  end
end
