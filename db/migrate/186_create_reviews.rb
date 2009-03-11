class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.column :user_id, :integer
      t.column :product_id, :integer

      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    add_index :reviews, :user_id
    add_index :reviews, :product_id
    add_index :reviews, :created_at
  end

  def self.down
    drop_table :reviews
  end
end
