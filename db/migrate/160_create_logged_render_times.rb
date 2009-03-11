class CreateLoggedRenderTimes < ActiveRecord::Migration
  def self.up
    create_table :logged_render_times do |t|
      t.column :controller_name, :string
      t.column :action_name, :string
      t.column :visit_count, :integer
      t.column :average, :float
      t.column :min, :float
      t.column :max, :float
      t.column :standard_deviation, :float
      t.column :is_total, :boolean, :default => false
      t.column :created_on, :date
    end
  end

  def self.down
    drop_table :logged_render_times
  end
end
