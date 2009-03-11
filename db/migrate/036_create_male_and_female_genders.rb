class CreateMaleAndFemaleGenders < ActiveRecord::Migration
  def self.up
    execute "INSERT INTO genders (name) VALUES ('Female')"
    execute "INSERT INTO genders (name) VALUES ('Male')"
  end

  def self.down
    execute "DELETE FROM genders"
  end
end
