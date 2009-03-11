module Additional
  module TabSystemHelper
    
    def interaction_tickbox(interaction_class)
      tickbox(interaction_class.exists_for(current_user, @user))
    end

    def tickbox(ticked)
      if ticked
        image_tag('profiles/tickedbox.png', :alt => 'You have done this', :class => 'tickbox')
      else
        image_tag('profiles/untickedbox.png', :alt => 'You haven\'t done this yet', :class => 'tickbox')
      end
    end
    
    def area_tabs
      content = @tab_details.map {|tab| area_tab(tab, @active_tab)}.join('')
      content_tag 'ul', content, :id => 'page_content_tabs'
    end
    
    def area_tab(tab, current_tab)
      options = {}
      options[:id] = area_tab_id(tab[0])
      options[:class] = "area_tab #{tab[0] == current_tab ? 'active' : 'inactive'}"
      content_tag 'li', link_to(content_tag('span', tab[1]), tab[2]), options
    end
    
    def area_tab_id(area)
      "#{area}_tab"
    end
    
    def own_profile?
      @user == current_user
    end
    
    def tab_page(&block)
      raise ArgumentError, "Missing block" unless block_given?

      content = capture(&block)
      concat('<div class="multi_page_content">', block.binding)
        concat(area_tabs, block.binding)
        concat('<div id="tabbable_page_content_container">', block.binding)
          concat('<div id="tabbable_page_content">', block.binding)
            concat('<div class="tabbable_page_body">', block.binding)
              concat(content, block.binding)
            concat('</div>', block.binding)
          concat('</div>', block.binding)
        concat('</div>', block.binding)
      concat('</div>', block.binding)
    end    
    
  end
end