class ConvertProductUrls < ActiveRecord::Migration
  def self.up
    for product in Product.find(:all)
      url = select_value "SELECT url FROM products WHERE id = #{product.id}"
      unless url.blank?
        ProductUrl.create(:original_url => url, :product_id => product.id)
      end
    end
  end

  def self.down
    ProductUrl.destroy_all
  end
end
