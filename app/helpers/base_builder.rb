class BaseBuilder < ActionView::Helpers::FormBuilder

  def image_selector(label, image_urls, options = {})
    if image_urls.empty?
      selector_text = "<span class=\"no_images\">No images found</span>"
    else
      image_elements = image_urls.map do |image_url|
        @template.content_tag('li', @template.radio_button(@object_name, label, image_url) + @template.image_tag(image_url, :alt => 'possible image', :size => '80x80'))
      end
      image_elements_joined = image_elements.join(' ') 
      if options[:empty_image_url]
        image_elements_joined += @template.content_tag('li', @template.radio_button(@object_name, label, '') + @template.image_tag(options[:empty_image_url], :alt => 'no image', :size => '80x80'))
      end
      selector_text = @template.content_tag('ul', image_elements_joined, :class => 'image_selections') + '<br class="section_end" />'
    end
    
    @template.content_tag('div', selector_text + '<br class="section_end" />', :class => 'image_selector') + '<br class="section_end" />'
  end
  
  def rating_selector(label, options)
    max = options[:max] || 5
    radio_buttons = (1..max).map do |score|
      button = @template.radio_button(@object_name, label, score)
      button_label = @template.content_tag('span', score, :class => 'button_label')
      @template.content_tag('span', button + ' ' + button_label, :class => 'button_and_label')
    end
    
    @template.content_tag('div', radio_buttons.join(' ') + '<br class="section_end" />', :class => 'rating_selector')
  end
  
  def textile_editor(method_name, options)
    @template.textile_editor(@object_name, method_name, options)
  end


end