
require 'rubygems'
require 'mechanize'
require 'hpricot'

module Yahoo
  class Scraper
    LOGIN_PAGE = 'https://login.yahoo.com/'
    ADULT_CONF_PAGE = 'http://groups.yahoo.com/adultconf'
    NAME_ELEMENT = 'span.ygrp-grdescr'
    DESCRIPTION_ELEMENT = '#ygr_desc'
  
    def initialize(account_options, new_page_fetcher = Yahoo::PageFetcher.new)
      @username = account_options[:username]
      @password = account_options[:password]
      raise ArgumentError unless @username && @password
      @page_fetcher = new_page_fetcher
    end

    def populate_group_data(group_name, group_data)
      doc = hpricot_doc_from(page_fetcher.group_page(group_name))
      populate_group_data_as_stranger(group_data, doc) if doc

      doc = hpricot_doc_from(page_fetcher.group_page_as_member(group_name, @username, @password))
      populate_group_data_as_member(group_data, doc) if doc
    end
    
    def visit_unbounce_url(url)
      raise Exception, "Visiting unbounce urls is not implemented yet. I need a new unbounce email to test it on."
    end
    
    def scrape_profile(profile)
      doc = hpricot_doc_from(page_fetcher.user_profile(profile.identifier))

      if doc && is_profile(doc)
  	    profile.viewable_on_yahoo = true
  	    profile.image_to_fetch = get_profile_image_url(doc)
  	    hobbies = get_hobbies(doc)
  	    profile.tag_string = hobbies unless hobbies.blank?
  	  else
  	    profile.viewable_on_yahoo = false
  	  end
	    profile.scraped_at = Time.now
    end
    
    def check_login(username, password)
      doc = hpricot_doc_from(page_fetcher.login_response_page(username, password))
      return false unless doc
      
      element = doc/'div.yregertxt'
      !(element && element.inner_html =~ /Invalid ID or password/)
    end
    
    def user_belongs_to_group?(username, password, group_name)
      raise ArgumentError if username.blank?
      raise ArgumentError if password.blank?
      raise ArgumentError if group_name.blank?
      
      #return false if !check_login(username, password)
      doc = hpricot_doc_from(page_fetcher.group_page_as_user(group_name, username, password))
      
      if doc
        for link in (doc / 'table.ygrp-header td.body a')
          return true if link.inner_html.strip == 'Edit Membership'
        end
      end
      false
    end
    
    protected
    
      def page_fetcher
        @page_fetcher
      end
      
      def has_menu_link?(doc, caption)
        doc.search("ul.menulist > li") do |list_item|
          list_item.search('a') do |link|
            return true if link.inner_html.strip == caption
          end
        end
        return false
      end
    
      def allows_messages?(doc)
        has_menu_link?(doc, 'Messages')
      end
      
      def allows_member_list?(doc)
        has_menu_link?(doc, 'Members')
      end
      
      def check_access(group_data, doc, level)
        group_data.minimum_archive_access_level = (allows_messages?(doc) ? level : 'off')
        group_data.minimum_members_list_access_level = (allows_member_list?(doc) ? level : 'off')
      end
      
      def populate_group_data_as_stranger(group_data, doc)
        check_access(group_data, doc, 'anyone')
      end

      def populate_group_data_as_member(group_data, doc)
        name_element = doc.search(NAME_ELEMENT)
        group_data.html_name = doc.search(NAME_ELEMENT).inner_html.gsub(/^&middot; /, '') if name_element

        description_element = doc.search(DESCRIPTION_ELEMENT)
        group_data.html_description = description_element.inner_html
        
        doc.search('#yginfo ul.ygrp-info li').each do |info_item|
          matchdata = info_item.inner_text.match(/Members: ([0-9]*)/)
          group_data.external_member_count = matchdata[1].to_i if matchdata
        end

        check_access(group_data, doc, 'members')
      end

      def get_profile_image_url(profile_page_doc)
        img = profile_page_doc.at("div.user-card > a > img")
        img ? img['src'] : nil
      end
      
      def is_profile(doc)
        doc.at('#ypfl-profile')
      end
      
      def get_hobbies(profile_page_doc)
        more_element = profile_page_doc.at('#ypfl-more')
        if more_element
          match_data = more_element.inner_html.match(/<dt>Hobbies:[^<]*<dd>([^<]*)<\/dd>/)
          if match_data
            return match_data[1]
          end
        end
        nil
      end
    
      def hpricot_doc_from(page_body)
        Hpricot(page_body) if page_body
      end

  end
end