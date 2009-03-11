class RemoveYahooProfileDuplicates < ActiveRecord::Migration
  def self.up
    for profile in YahooProfile.find(:all, :order => 'created_at ASC')
      if YahooProfile.exists?(["identifier = ? && id != ?", profile.identifier, profile.id])
        profile.destroy
      end
    end
  end

  def self.down
  end
end
