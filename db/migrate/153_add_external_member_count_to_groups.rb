class AddExternalMemberCountToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :external_member_count, :integer
  end

  def self.down
    remove_column :groups, :external_member_count
  end
end
