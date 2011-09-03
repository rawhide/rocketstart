module Railstar
  module Helper
    def title(page_title)
      content_for(:title) { page_title }
    end

    def stylesheet(*css)
      content_for(:head) { stylesheet_link_tag(*css) }
    end

    def javascript(*js)
      content_for(:head) { javascript_include_tag(*js) }
    end

    def auto_discovery_rss(rss)
      content_for(:head) do
        %Q(<link rel="alternate" type="application/rss+xml" href="#{rss}" title="RSS 2.0" />)
      end
    end

    def hbr(str)
      str = html_escape(str)
      br(str)
    end

    def br(str)
      str.gsub(/\r\n|\r|\n/, "<br />")
    end

    def url2link(str)
      str.gsub(/(https?:\/\/[-_.!~*'()a-zA-Z0-9;\/?:@&=+$,%#]+)/){"<a href='#{$1}'>#{$1}</a>"}
    end

    def params_to_hidden_tag(object, options={})
      p = options[:prefix].blank? ? params[object] : params[options[:prefix]][object]
      str = ""
      str << hidden_field_tag('back', 1) if options[:back]
      return str unless p
      p.each do |method,value|
        if options[:except] && options[:except].include?(method.to_sym)
        else
          #nested_attributes対応
          if value.is_a?(Hash)
            nested_attributes_key = method
            value.each do |method, val|
              name = options[:prefix].blank? ? "#{object}[#{nested_attributes_key}]" : "#{options[:prefix]}[#{object}][#{nested_attributes_key}"
              str << hidden_field(name, method, :value => value[method])
            end
          else
            name = options[:prefix].blank? ? object : "#{options[:prefix]}[#{object}]"
            str << hidden_field(object,method, :value => p[method])
          end
        end
      end
      str
    end

    def save_action(object, options={})
      if object.new_record?
        {:action => "create"}
      else
        {:action => "update", :id => object}
      end.merge(options)
    end
  end
end
