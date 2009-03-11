class SetDefaultCreatedOnForStories < ActiveRecord::Migration
  def self.up
    execute "UPDATE stories SET created_on = NOW()"
  end

  def self.down
  end
end
