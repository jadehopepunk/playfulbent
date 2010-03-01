# == Schema Information
#
# Table name: product_images
#
#  id                 :integer(4)      not null, primary key
#  original_image_url :string(255)
#  parent_id          :integer(4)
#  content_type       :string(255)
#  filename           :string(255)
#  thumbnail          :string(255)
#  size               :integer(4)
#  width              :integer(4)
#  height             :integer(4)
#  product_id         :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class ProductImageTest < Test::Unit::TestCase
  fixtures :product_images

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
