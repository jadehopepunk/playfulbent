
module Yahoo
  class PageFetcher
    LOGIN_PAGE = 'https://login.yahoo.com/'
    ADULT_CONF_PAGE = 'http://groups.yahoo.com/adultconf'
    
    def user_profile(yahoo_username)
      begin
        profile_url = "http://profiles.yahoo.com/#{yahoo_username}?warn=1"
        return open(profile_url)
      rescue Exception
        nil
      end    
    end
    
    def group_page(group_name)
      agent(true).get(group_url(group_name)).body
    end
    
    def group_page_as_member(group_name, username, password)
      group_page_as_user(group_name, username, password)
    end
    
    def group_page_as_user(group_name, username, password)
      page = agent(true).get(LOGIN_PAGE)

      form = page.forms.name('login_form').first
      form.login = username
      form.passwd = password
      page = agent.submit(form)

      begin
        page = agent.get(ADULT_CONF_PAGE)

        form = page.forms[1]
        button = form.buttons[0]
        page = agent.submit(form, button)
      rescue Exception => e
      end

      agent.get(group_url(group_name)).body
    end
    
    def login_response_page(username, password)
      page = agent(true).get(LOGIN_PAGE)

      form = page.forms.name('login_form').first
      form.login = username
      form.passwd = password
      agent.submit(form).body
    end
    
    def group_url(group_name)
      "http://groups.yahoo.com/group/#{group_name}/"
    end
    
    protected
    
      def agent(start_new = false)
        if @agent.nil? || start_new
          @agent = WWW::Mechanize.new
          @agent.user_agent_alias = 'Mac Safari'
        end
        @agent
      end
    
  end
end