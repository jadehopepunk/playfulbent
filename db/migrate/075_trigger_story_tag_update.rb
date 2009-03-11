class TriggerStoryTagUpdate < ActiveRecord::Migration
  def self.up
    for version in PageVersion.find(:all)
      version.save!
    end
  end

  def self.down
  end
end
