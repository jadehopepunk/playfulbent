class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.column :type, :string
      t.column :actor_id, :integer
      t.column :gallery_photo_id, :integer
      
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    add_index :activities, :gallery_photo_id
  end

  def self.down
    drop_table :activities
  end
end
