class AddSubjectToConversations < ActiveRecord::Migration
  def self.up
    add_column :conversations, :subject_id, :integer
    add_column :conversations, :subject_type, :string
  end

  def self.down
    remove_column :conversations, :subject_id
    remove_column :conversations, :subject_type
  end
end
