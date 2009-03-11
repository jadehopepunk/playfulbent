class CreateInteractions < ActiveRecord::Migration
  def self.up
    create_table :interactions do |t|
      t.column :actor_id, :integer
      t.column :subject_id, :integer
      t.column :type, :string
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :interactions
  end
end
