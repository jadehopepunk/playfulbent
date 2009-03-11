class AddMembersListAccessLevelToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :members_list_access_level, :string
  end

  def self.down
    remove_column :groups, :members_list_access_level
  end
end
