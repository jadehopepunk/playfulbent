class AddGenderToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :gender_id, :integer
  end

  def self.down
    remove_column :profiles, :gender_id
  end
end
