class AddSexualityToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :likes_boys, :boolean, :null => true
    add_column :profiles, :likes_girls, :boolean, :null => true
  end

  def self.down
    remove_column :profiles, :likes_boys
    remove_column :profiles, :likes_girls
  end
end
