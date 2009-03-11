class CreateDares < ActiveRecord::Migration
  def self.up
    create_table :dares do |t|
      t.column :request, :text
      t.column :requires_photo, :boolean
      t.column :requires_description, :boolean
      t.column :created_on, :datetime
      t.column :creator_id, :integer
    end
  end

  def self.down
    drop_table :dares
  end
end
