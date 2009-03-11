class CreateInteractionCounts < ActiveRecord::Migration
  def self.up
    create_table :interaction_counts do |t|
      t.column :actor_id, :integer
      t.column :subject_id, :integer
      t.column :number, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :interaction_counts
  end
end
