class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.column :category, :string
      t.column :url, :string
      t.column :name, :string

      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    add_index :products, :category
  end

  def self.down
    drop_table :products
  end
end
