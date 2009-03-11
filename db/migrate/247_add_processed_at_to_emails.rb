class AddProcessedAtToEmails < ActiveRecord::Migration
  def self.up
    add_column :emails, :processed_at, :datetime
  end

  def self.down
    remove_column :emails, :processed_at
  end
end
