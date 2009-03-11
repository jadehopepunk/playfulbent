class CreateSponsorshipPayments < ActiveRecord::Migration
  def self.up
    create_table :sponsorship_payments do |t|
      t.column :sponsorship_id, :integer
      t.column :amount_cents, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :sponsorship_payments
  end
end
