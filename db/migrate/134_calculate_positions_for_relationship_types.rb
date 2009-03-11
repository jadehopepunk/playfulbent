class CalculatePositionsForRelationshipTypes < ActiveRecord::Migration
  def self.up
    for user in User.find(:all)
      position = 1
      for relationship_type in RelationshipType.find(:all, :order => 'id ASC', :conditions => {:user_id => user.id})
        execute "UPDATE relationship_types SET position = #{position} WHERE id = #{relationship_type.id}"
        position += 1
      end
    end
  end

  def self.down
  end
end
