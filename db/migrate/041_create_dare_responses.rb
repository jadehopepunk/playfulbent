class CreateDareResponses < ActiveRecord::Migration
  def self.up
    create_table :dare_responses do |t|
      t.column :user_id, :integer
      t.column :dare_id, :integer
      t.column :created_on, :datetime
      t.column :description, :text
      t.column :photo, :string
    end
  end

  def self.down
    drop_table :dare_responses
  end
end
