class CreateFlickrAccounts < ActiveRecord::Migration
  def self.up
    create_table :flickr_accounts do |t|
      t.column :nsid, :string
      t.column :token, :string
      t.column :username, :string
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    add_index :flickr_accounts, :user_id
  end

  def self.down
    drop_table :flickr_accounts
  end
end
