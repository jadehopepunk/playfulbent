module Additional
  module TagHelper
    
    def global_tag_cloud(tag_ranks)
      tag_ranks_hash = {}
      for tag_rank in tag_ranks
        tag_ranks_hash[tag_rank.tag] = tag_rank.global_ratio
      end

      base_url_params = params.reject {|key, value| key == 'tag'}
      global_tag_cloud_from_hash(tag_ranks_hash)
    end

    def global_tag_cloud_from_hash(tag_ranks_hash)
      tag_ranks_array = tag_ranks_hash.sort {|a, b| a[0].name <=> b[0].name}

      tag_spans = tag_ranks_array.collect do |tag_and_rank|
        tag, rank = tag_and_rank
        link_to tag.to_s, tag_url(tag), :class => "tag tag#{rank}"
      end
      content_tag('div', tag_spans.join(", "), :class => 'tag_cloud')
    end

    def tag_cloud(tag_ranks, ratio_method)
      tag_ranks_hash = {}
      for tag_rank in tag_ranks
        tag_ranks_hash[tag_rank.tag] = tag_rank.send(ratio_method)
      end
      
      base_url_params = params.reject {|key, value| key == 'tag'}
      tag_cloud_from_hash(tag_ranks_hash, url_for(base_url_params))
    end

    def tag_cloud_from_hash(tag_ranks_hash, base_url)
      tag_ranks_array = tag_ranks_hash.sort {|a, b| a[0].name <=> b[0].name}

      tag_spans = tag_ranks_array.collect do |tag_and_rank|
        tag, rank = tag_and_rank
        classes = ['tag']
        classes << ["tag#{rank}"]
        classes << 'active_tag' if @tag == tag.name
        if @tag == tag.name
          uri = base_url
        else
          separator = base_url.include?('?') ? '&' : '?'
          uri = base_url + separator + 'tag=' + URI.escape(tag.to_param)
        end
        link_to tag.to_s, uri, :class => classes.join(' ')
      end
      show_all = @tag ? link_to('Show All', base_url, :class => 'clear_tag_link') : ''
      content_tag('div', tag_spans.join(", ") + show_all, :class => 'tag_cloud')
    end

    def format_tag_list(tags)
      tag_tags = tags.collect do |tag|
  		  content_tag 'span', tag.to_s, :class => 'tag'
      end
      divider = '&nbsp;' + content_tag('span', '&nbsp;', :class => 'tag_divider') + ' '
      tag_tags.join(divider)
    end

    def format_tag_links(tags)
      tag_tags = tags.collect do |tag|
  		  link_to tag.to_s, url_for_tag(tag), :class => 'tag'
      end
      divider = '&nbsp;' + content_tag('span', '&nbsp;', :class => 'tag_divider') + ' '
      tag_tags.join(divider)
    end    
    
    def url_for_tag(tag)
      base_url_params = params.reject {|key, value| key == 'tag'}
      base_url = url_for(base_url_params)

      if @tag == tag.name
        uri = base_url
      else
        separator = base_url.include?('?') ? '&' : '?'
        uri = base_url + separator + 'tag=' + URI.escape(tag.to_param)
      end
      uri
    end
    
    def dont_display
      ' style="display: none"'
    end   
    
  end
  
end