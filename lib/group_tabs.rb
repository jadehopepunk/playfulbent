module GroupTabs
  
  def load_tabs(active_tab)
    @tab_details = []
    @tab_details << [:summary, 'About Us', group_path(@group)]
    @tab_details << [:members, 'Members', group_group_members_path(@group)]
    @tab_details << [:mailing_list, 'Mailing List', group_mailing_list_messages_path(@group)]
    @active_tab = active_tab
  end  
  
end