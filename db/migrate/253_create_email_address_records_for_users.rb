class CreateEmailAddressRecordsForUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end
  
  class EmailAddress < ActiveRecord::Base
  end
  
  def self.up
    User.find_each do |user|
      unless user.email.blank?
        email_address = EmailAddress.create!(:address => user.email, :user_id => user.id)
        email_address.created_at = user.created_on
        email_address.save!
        
        user.primary_email_address_id = email_address.id
        user.save!
      end
    end
  end

  def self.down
    EmailAddress.delete_all
  end
end
