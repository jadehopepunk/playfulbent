class RemoveCategoryFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :category
  end

  def self.down
    add_column :products, :category, :string
  end
end
