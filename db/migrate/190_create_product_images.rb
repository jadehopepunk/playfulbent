class CreateProductImages < ActiveRecord::Migration
  def self.up
    create_table :product_images do |t|
      t.column :original_image_url, :string
      
      t.column :parent_id,  :integer
      t.column :content_type, :string
      t.column :filename, :string    
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer

      t.column :product_id, :integer
      
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    add_index :product_images, :parent_id
    add_index :product_images, :product_id
  end

  def self.down
    drop_table :product_images
  end
end
