class CreateEmailAddresses < ActiveRecord::Migration
  def self.up
    create_table :email_addresses do |t|
      t.string :address
      t.datetime :verified_at
      t.integer :user_id
    
      t.timestamps
    end
    
    add_index :email_addresses, :user_id
  end

  def self.down
    drop_table :email_addresses
  end
end
