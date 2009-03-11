class RemoveGenderIdFromProfiles < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :gender_id
  end

  def self.down
    add_column :profiles, :gender_id, :integer
  end
end
