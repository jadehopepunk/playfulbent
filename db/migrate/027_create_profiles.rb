class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.column :user_id, :integer
      t.column :created_on, :integer
    end
  end

  def self.down
    drop_table :profiles
  end
end
