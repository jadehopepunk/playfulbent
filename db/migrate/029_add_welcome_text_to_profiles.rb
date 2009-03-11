class AddWelcomeTextToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :welcome_text, :text, :null => false, :default => ''
  end

  def self.down
    remove_column :profiles, :welcome_text
  end
end
