class CalculateStoryUpdatedAtFromVersionCreatedOn < ActiveRecord::Migration
  def self.up
    for story in Story.find(:all)
      execute "UPDATE stories SET updated_at = (SELECT MAX(created_on) FROM page_versions WHERE story_id = #{story.id}) WHERE id = #{story.id}"
    end
  end

  def self.down
  end
end
