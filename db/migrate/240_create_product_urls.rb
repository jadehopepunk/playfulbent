class CreateProductUrls < ActiveRecord::Migration
  def self.up
    create_table :product_urls do |t|
      t.column :original_url, :string
      t.column :affiliate_url, :string
      t.column :product_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    add_index :product_urls, :product_id
  end

  def self.down
    drop_table :product_urls
  end
end
