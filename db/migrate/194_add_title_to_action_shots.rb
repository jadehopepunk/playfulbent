class AddTitleToActionShots < ActiveRecord::Migration
  def self.up
    add_column :action_shots, :title, :string
  end

  def self.down
    remove_column :action_shots, :title
  end
end
