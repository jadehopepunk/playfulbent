class RemoveEmailColumnFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :email
  end

  def self.down
    add_column :users, :email, :string
    Object.class_eval "class User < ActiveRecord::Base\nend"
    Object.class_eval "class EmailAddress < ActiveRecord::Base\nend"
    
    User.find_each do |user|
      if user.primary_email_address_id
        email_address = EmailAddress.find(user.primary_email_address_id)
        user.email = email_address.address
        user.save
      end
    end
  end
end
