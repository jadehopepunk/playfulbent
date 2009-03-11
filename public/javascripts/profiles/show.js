function switchTabs(area)
{
  $$('#tabbable_page_content div.tabbable_page_body').each(function(value) { value.hide(); });
  Element.show(area);
  $$('#page_content_tabs li.area_tab').each(function(value) { value.className = 'area_tab inactive'; });
  $(area + '_icon').className = 'area_tab active'; 
}

