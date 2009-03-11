class CreateSponsorships < ActiveRecord::Migration
  def self.up
    create_table :sponsorships do |t|
      t.column :user_id, :integer
      t.column :amount_cents, :integer
      t.column :created_at, :datetime
      t.column :cancelled_at, :datetime
    end
  end

  def self.down
    drop_table :sponsorships
  end
end
