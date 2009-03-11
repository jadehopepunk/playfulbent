class CreateInterests < ActiveRecord::Migration
  def self.up
    create_table :interests do |t|
      t.column :profile_id, :integer
    end
  end

  def self.down
    drop_table :interests
  end
end
