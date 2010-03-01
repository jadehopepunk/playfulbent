# == Schema Information
#
# Table name: product_urls
#
#  id            :integer(4)      not null, primary key
#  original_url  :string(255)
#  affiliate_url :string(255)
#  product_id    :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#

class ProductUrl < ActiveRecord::Base
  belongs_to :product
  
  validates_presence_of :original_url
  
  def url
    affiliate_url.blank? ? original_url : affiliate_url
  end
  
  def original_url=(value)
    changed_value = (!(value.blank? || value =~ /^[a-zA-Z]*\:\/\//) ? 'http://' + value : value)
    write_attribute(:original_url, changed_value)
  end
  
end
