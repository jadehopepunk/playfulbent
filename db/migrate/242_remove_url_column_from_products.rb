class RemoveUrlColumnFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :url
  end

  def self.down
    add_column :products, :url, :string
  end
end
