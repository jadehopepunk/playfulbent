class CreateDareChallenges < ActiveRecord::Migration
  def self.up
    create_table :dare_challenges do |t|
      t.column :user_id, :integer
      t.column :subject_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :dare_challenges
  end
end
