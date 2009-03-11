class RemoveNullGenders < ActiveRecord::Migration
  def self.up
    execute "UPDATE profiles SET gender_id = NULL WHERE gender_id IN (SELECT id FROM genders WHERE name = '' OR name IS NULL);"
    execute "DELETE FROM genders WHERE name = '' OR name IS NULL"
  end

  def self.down
  end
end
