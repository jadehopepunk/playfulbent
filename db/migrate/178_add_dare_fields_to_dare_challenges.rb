class AddDareFieldsToDareChallenges < ActiveRecord::Migration
  def self.up
    add_column :dare_challenges, :dare_level, :string, :default => 'flirty'
    add_column :dare_challenges, :subject_dare_text, :text
    add_column :dare_challenges, :user_dare_text, :text
  end

  def self.down
    remove_column :dare_challenges, :dare_level
    remove_column :dare_challenges, :subject_dare_text
    remove_column :dare_challenges, :user_dare_text
  end
end
