class AddTypeToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :type, :string
    execute "UPDATE products SET type = 'ProductSexToy'"
    add_index :products, :type
  end

  def self.down
    remove_index :products, :type
    remove_column :products, :type
  end
end
