class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
      t.column :title, :string
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :conversations
  end
end
