class CleanUpAfterDareTaggingsBug < ActiveRecord::Migration
  def self.up
    execute "DELETE FROM taggings WHERE taggable_type = 'Dare' AND (taggable_id IS NULL OR taggable_id = '')"
  end

  def self.down
  end
end
