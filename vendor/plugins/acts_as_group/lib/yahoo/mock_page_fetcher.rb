
module Yahoo
  class MockPageFetcher
    
    def user_profile(yahoo_username)
      raise NotImplementedError, 'user_profile'
    end
    
    def group_page(group_name)
      raise NotImplementedError, 'group_page'
    end
    
    def group_page_as_member(group_name, username, password)
      raise NotImplementedError, 'group_page_as_member'
    end
    
    def group_page_as_user(group_name, username, password)
      raise NotImplementedError, 'group_page_as_user'
    end
    
    def login_response_page(username, password)
      raise NotImplementedError, 'login_response_page'
    end
   
    def group_url(group_name)
      "http://groups.yahoo.com/group/#{group_name}/"
    end
        
  end
end