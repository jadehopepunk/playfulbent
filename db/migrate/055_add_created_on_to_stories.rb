class AddCreatedOnToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :created_on, :datetime
  end

  def self.down
    remove_column :stories, :created_on
  end
end
