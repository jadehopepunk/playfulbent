class EnsurePhotoSetsHaveDefaultViewableBy < ActiveRecord::Migration
  def self.up
    for set in PhotoSet.find(:all, :conditions => "viewable_by IS NULL OR viewable_by = ''")
      set.update_attribute(:viewable_by, 'everyone')
    end
  end

  def self.down
  end
end
