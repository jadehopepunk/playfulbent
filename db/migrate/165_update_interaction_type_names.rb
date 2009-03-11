class UpdateInteractionTypeNames < ActiveRecord::Migration
  def self.up
    names = %w(ExchangeMessages FriendWith HaveDarePerformed IsFriendOf PerformDare ShowStripshow ViewStripshow WriteInSameStory)
    for name in names
      execute "UPDATE interactions SET type = 'Interaction#{name}' WHERE type= '#{name}'"
    end
  end

  def self.down
  end
end
