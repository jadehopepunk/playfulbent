class TriggerProfileTagUpdate < ActiveRecord::Migration
  def self.up
    for interests in Interests.find(:all)
      interests.save!
    end
    for kinks in Kinks.find(:all)
      kinks.save!
    end
  end

  def self.down
  end
end
