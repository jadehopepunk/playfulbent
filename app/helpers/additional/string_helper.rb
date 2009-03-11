module Additional
  module StringHelper
    
    def format_percent(value)
      "#{(value * 100).to_i}%"
    end
    
    def nl2lb(value)
      value.gsub("\n", "<br />\n")
    end

    def pre_truncate(string, max_length)
      truncate(string.reverse, max_length).reverse
    end

    def text_preview(string, max_length)
      simple_format(h(truncate(string, max_length)))
    end

    
    
  end
end