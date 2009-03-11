class AddSexualityToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :likes_boys, :boolean, :null => true
    add_column :users, :likes_girls, :boolean, :null => true
  end

  def self.down
    remove_column :users, :likes_boys
    remove_column :users, :likes_girls
  end
end
