class CreateTagRanks < ActiveRecord::Migration
  def self.up
    create_table :tag_ranks do |t|
      t.column :tag_id, :integer
      t.column :story_count, :integer
      t.column :profile_count, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    add_index :tag_ranks, :story_count
    add_index :tag_ranks, :profile_count
  end

  def self.down
    remove_index :tag_ranks, :profile_count
    remove_index :tag_ranks, :story_count
    
    drop_table :tag_ranks
  end
end
