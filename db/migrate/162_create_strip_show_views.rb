class CreateStripShowViews < ActiveRecord::Migration
  def self.up
    create_table :strip_show_views do |t|
      t.column :strip_show_id, :integer
      t.column :user_id, :integer
      t.column :max_position_viewed, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :strip_show_views
  end
end
