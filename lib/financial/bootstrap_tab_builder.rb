module Financial
  class BootstrapLinkTabBuilder < TabsOnRails::Tabs::Builder
    def open_tabs(options = {})
    end
  
    def close_tabs(options = {})
    end
  
    def tab_for(tab, name, url_options, item_options = {})
      item_options[:class] = item_options[:class].to_s.split(" ").push(@options[:active_class] || "active").join(" ") if current_tab?(tab)
      content = @context.link_to_unless(current_tab?(tab), name, url_options) do
        @context.link_to(name, '#')
      end
      @context.content_tag(:li, content, item_options)
    end
  end

  class BootstrapDropDownTabBuilder < TabsOnRails::Tabs::Builder
    def open_tabs(options = {})
    end
  
    def close_tabs(options = {})
    end
  
    def tab_for(tab, name, url_options, item_options = {})
      item_options[:class] = item_options[:class].to_s.split(" ").push(@options[:active_class] || "active").join(" ") if current_tab?(tab)
      content = ActiveSupport::SafeBuffer.new(name)
      content << @context.content_tag(:b, "", {:class=>'caret'})
      content = @context.link_to(content, '#', {:class=>"dropdown-toggle", 'data-toggle'=>"dropdown"})
      @context.content_tag(:li, content, item_options)
    end
  end
end