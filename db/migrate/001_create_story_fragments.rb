class CreateStoryFragments < ActiveRecord::Migration
  def self.up
      create_table :story_fragments do |table|
        table.column(:text,  :text)
      end
  end

  def self.down
      drop_table :users
  end
end
