class WelcomeTextDoesntHaveToBeNull < ActiveRecord::Migration
  def self.up
    change_column_default :profiles, :welcome_text, ''
  end

  def self.down
  end
end
