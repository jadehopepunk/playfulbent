
class Page
  
  attr_reader :parent
  
  def initialize(parent, version_array)
    @parent = parent
    @versions = version_array
  end
  
  def versions(user = nil)
    return @versions if user.nil?
    
    @versions.sort do |a, b|
      b.being_followed_by(user).to_s <=> a.being_followed_by(user).to_s
    end
  end
  
  def first_added_version
    @versions.first
  end
  
  def page_number
    result = 1
    result += @parent.page_number unless @parent.nil?
    result
  end
  
  def story
    return @parent.story unless @parent.nil?
    return versions.first.story unless versions.empty?
  end
  
  def grandparent
    parent.parent unless parent.nil?
  end
  
  def authors
    result = (parent.nil? ? [] : parent.authors)
    result += (versions.collect {|version| version.author})
    result.uniq
  end
  
  def version_authors
    result = (versions.collect {|version| version.author})
    result.uniq
  end
  
  def followers
    result = []
    for version in versions
      result += version.followers
    end
    result.uniq
  end
  
  def can_have_alternative?
    !parent.nil?
  end
  
  def being_followed_by(user)
    for version in versions
      return true if version.being_followed_by(user)
    end
    false
  end
  
  def children
    versions.collect {|version| version.page}
  end
  
  def read_by(viewing_user)
    for version in versions
      return true if version.being_followed_by(viewing_user)
    end
    false
  end
  
  def children_read_by(viewing_user)
    children.reject {|child| !child.read_by(viewing_user) }
  end
  
  def get_read_leaf_pages_except(viewing_user, except_page = nil)
    results = []
    for page in children_read_by(viewing_user)
      if page.is_leaf_for(viewing_user) && (except_page.nil? || !is_parent_of?(except_page))
        results << page
      else  
        results += page.get_read_leaf_pages_except(viewing_user, except_page)
      end
    end
    results
  end
  
  def is_parent_of?(other_page)
    @versions.include?(other_page.parent)
  end
  
  def is_leaf_for(viewing_user)
    children_read_by(viewing_user).empty?
  end
  
  def on_viewed(viewing_user)
    parent.follow(viewing_user) unless parent.nil?
    
    if @versions.length == 1 && (parent.nil? || parent.being_followed_by(viewing_user)) 
      @versions.first.follow(viewing_user)
    end
    
    for version in @versions
      version.mark_as_read_by(viewing_user)
    end
  end

end