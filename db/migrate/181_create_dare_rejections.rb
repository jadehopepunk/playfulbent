class CreateDareRejections < ActiveRecord::Migration
  def self.up
    create_table :dare_rejections do |t|
      t.column :dare_challenge_id, :integer
      t.column :user_id, :integer
      t.column :rejected_dare_text, :text
      t.column :rejection_reason_text, :text
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :dare_rejections
  end
end
