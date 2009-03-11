class RenumberComments < ActiveRecord::Migration
  def self.up
    Comment.renumber_all
  end

  def self.down
  end
end
