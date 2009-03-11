class ValidateExistingEmailAddresses < ActiveRecord::Migration
  def self.up
    execute "UPDATE email_addresses SET verified_at = NOW()"
  end

  def self.down
  end
end
