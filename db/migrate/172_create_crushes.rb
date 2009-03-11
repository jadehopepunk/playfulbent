class CreateCrushes < ActiveRecord::Migration
  def self.up
    create_table :crushes do |t|
      t.column :user_id, :integer
      t.column :subject_id, :integer
      t.column :fantasy, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :crushes
  end
end
