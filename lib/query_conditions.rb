class QueryConditions
  
  def self.append(conditions, new_conditions, operator = 'AND')
    return new_conditions if conditions.nil?
    raise ArgumentError unless conditions.is_a?(String) || (conditions.is_a?(Array) && !conditions.empty? && conditions.first.is_a?(String))
    raise ArgumentError unless new_conditions.is_a?(String) || (new_conditions.is_a?(Array) && !new_conditions.empty? && new_conditions.first.is_a?(String))
    
    new_conditions_string = (new_conditions.is_a?(Array) ? new_conditions[0] : new_conditions)
    
    conditions = [conditions] if conditions.is_a?(String)
    
    conditions[0] = "(#{conditions[0]}) #{operator} (#{new_conditions_string})"
    conditions = conditions.concat(new_conditions[1..-1]) if new_conditions.is_a?(Array)
    conditions
  end
  
  def self.for_search(search_field, query)
    keys = query.split(' ').reject(&:blank?)
    conditions = nil
    for key in keys
      like_query = "%#{key}%"
      conditions = append(conditions, ["#{search_field} LIKE ?", like_query], 'AND')
    end
    conditions
  end  
  
  def self.append_for_search(conditions, search_field, query, operator = 'AND')
    QueryConditions.append(conditions, QueryConditions.for_search(search_field, query), operator)
  end
  
end