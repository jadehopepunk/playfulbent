class CreateYahooProfiles < ActiveRecord::Migration
  def self.up
    create_table :yahoo_profiles do |t|
      t.column :identifier, :string
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :yahoo_profiles
  end
end
