
module Yahoo
  class MockScraper
  
    def initialize(account_options)
      raise ArgumentError unless account_options[:username] && account_options[:password]
    end
    
    def populate_group_data(group_name, group_data)
      group_data.name = group_name
    end
  
    def get_profile_image_url(profile_name)
    end
  
    def visit_unbounce_url(url)
    end
    
    def check_login(username, password)
      raise NotImplementedError
    end

    def user_belongs_to_group?(username, password, group_name)
      raise NotImplementedError
    end
  
  end
end