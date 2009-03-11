class CreateChapterPreferences < ActiveRecord::Migration
  def self.up
    create_table :chapter_preferences do |t|
      t.column :user_id, :integer
      t.column :story_fragment_id, :integer
    end
  end

  def self.down
    drop_table :chapter_preferences
  end
end
