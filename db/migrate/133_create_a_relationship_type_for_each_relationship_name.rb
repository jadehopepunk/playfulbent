class CreateARelationshipTypeForEachRelationshipName < ActiveRecord::Migration
  def self.up
    for relationship_type in RelationshipType.find(:all)
      relationships = Relationship.find(:all, :conditions => {:relationship_type_id => relationship_type.id})
      name = select_value "SELECT name FROM relationship_types WHERE id = #{relationship_type.id}"
      
      for relationship in relationships
        user_id = select_value "SELECT user_id FROM relationships WHERE id = #{relationship.id}"
        new_relationship_type = self.find_or_create_relationship_type(name, user_id)
        execute "UPDATE relationships SET relationship_type_id = #{new_relationship_type.id} WHERE id = #{relationship.id}"
      end
    end
    
    execute "DELETE FROM relationship_types WHERE user_id IS NULL"
  end

  def self.down
  end
  
  protected
  
    def self.find_or_create_relationship_type(name, user_id)
      RelationshipType.find(:first, :conditions => {:name => name, :user_id => user_id}) || RelationshipType.create(:name => name, :user_id => user_id)
    end
  
end
