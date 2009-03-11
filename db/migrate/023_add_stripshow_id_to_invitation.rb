class AddStripshowIdToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :strip_show_id, :integer
  end

  def self.down
    remove_column :invitations, :strip_show_id
  end
end
