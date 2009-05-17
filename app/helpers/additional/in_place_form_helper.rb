module Additional
  module InPlaceFormHelper

    def in_place_editor(field_id, options = {})
      function =  "new Ajax.InPlaceEditor("
      function << "'#{field_id}', "
      function << "'#{url_for(options[:url])}'"

      js_options = {}
      js_options['cancelText'] = %('#{options[:cancel_text]}') if options[:cancel_text]
      js_options['okText'] = %('#{options[:save_text]}') if options[:save_text]
      js_options['loadingText'] = %('#{options[:loading_text]}') if options[:loading_text]
      js_options['rows'] = options[:rows] if options[:rows]
      js_options['cols'] = options[:cols] if options[:cols]
      js_options['size'] = options[:size] if options[:size]
      js_options['externalControl'] = "'#{options[:external_control]}'" if options[:external_control]
      js_options['loadTextURL'] = "'#{url_for(options[:load_text_url])}'" if options[:load_text_url]        
      js_options['ajaxOptions'] = options[:options] if options[:options]
      js_options['evalScripts'] = options[:script] if options[:script]
      js_options['highlightendcolor'] = options[:highlightendcolor] if options[:highlightendcolor]
      js_options['highlightcolor'] = options[:highlightcolor] if options[:highlightcolor]
      js_options['callback']   = "function(form) { return #{options[:with]} }" if options[:with]
      function << (', ' + options_for_javascript(js_options)) unless js_options.empty?

      function << ')'

      javascript_tag(function)
    end

    def link_to_inline_form_if(condition, record, form_partial, controller_name = nil, &proc)
      if condition
        link_to_inline_form(record, form_partial, controller_name, &proc)
      else
        yield
      end
    end

    def link_to_inline_form(record, form_partial, controller_name = nil, &proc)
      form_partial_template = "#{controller_name ? controller_name.to_s + '/' : ''}#{form_partial.to_s}"
      form = render(:partial => form_partial_template)
      form_id = dom_id(record, "#{form_partial}_form")
      display_id = dom_id(record, "#{form_partial}_display")
      rollover_link_id = dom_id(record, "#{form_partial}_edit_link")
      
      form_container = content_tag('div', form, :class => 'inline_form_container', :style => 'display:none', :id => form_id)
      edit_link = link_to_function('Click to Edit', "Element.show('#{form_id}'); Element.hide('#{display_id}')", :class => 'rollover_link', :id => rollover_link_id, :style => 'display:none')
      rollover_link_bar = content_tag('div', edit_link, :class => 'rollover_link_bar')
      display_container_edit_start = "<div class=\"inline_form_display_container\" id=\"#{display_id}\" onmouseover=\"Element.show('#{rollover_link_id}')\" onmouseout=\"Element.hide('#{rollover_link_id}')\">"
      display_container_edit_start << rollover_link_bar
      display_container_no_edit_start = "<div class=\"inline_form_no_edit_display_container\" id=\"#{display_id}\">"
      
      result = ''
      if record.can_be_edited_by?(current_user)
        result += form_container 
        result += display_container_edit_start
      else
        result += display_container_no_edit_start
      end
      concat(result)
      yield
      concat("</div>")
    end
    
    def inline_form_footer(record, form_partial)
      form_id = dom_id(record, "#{form_partial}_form")
      display_id = dom_id(record, "#{form_partial}_display")
      content_tag('div', submit_tag('Save') + ' ' + spinner(form_partial.to_s) + ' or ' + link_to_function("Cancel", "Element.hide('#{form_id}'); Element.show('#{display_id}')"), :class => 'editable_form_buttons')
    end
  
  end
end