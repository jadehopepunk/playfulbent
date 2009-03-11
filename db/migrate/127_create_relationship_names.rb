class CreateRelationshipNames < ActiveRecord::Migration
  def self.up
    create_table :relationship_names do |t|
      t.column :name, :string
      t.column :popularity, :integer, :default => 0
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :relationship_names
  end
end
