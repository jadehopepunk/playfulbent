class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.column :country, :string
      t.column :city, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :locations
  end
end
