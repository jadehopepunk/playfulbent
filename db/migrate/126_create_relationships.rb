class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.column :user_id, :integer
      t.column :subject_id, :integer
      t.column :relationship_name_id, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :relationships
  end
end
