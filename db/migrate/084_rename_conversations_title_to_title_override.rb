class RenameConversationsTitleToTitleOverride < ActiveRecord::Migration
  def self.up
    rename_column :conversations, :title, :title_override
  end

  def self.down
    rename_column :conversations, :title_override, :title
  end
end
