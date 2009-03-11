class CreateAvatars < ActiveRecord::Migration
  def self.up
    create_table :avatars do |t|
      t.column :image, :string
      t.column :profile_id, :integer
    end
  end

  def self.down
    drop_table :avatars
  end
end
