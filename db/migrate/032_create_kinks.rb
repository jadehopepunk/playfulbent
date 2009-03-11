class CreateKinks < ActiveRecord::Migration
  def self.up
    create_table :kinks do |t|
      t.column :profile_id, :integer
    end
  end

  def self.down
    drop_table :kinks
  end
end
