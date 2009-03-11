class CreateInteractionCountsForInteractions < ActiveRecord::Migration
  def self.up
    for interaction in Interaction.find(:all)
      interaction.send(:update_interaction_count)
    end
  end

  def self.down
  end
end
