module ApplicationHelper
  def paginate_for(records)
    content_tag :div, paginate(@users), class: 'paginate-nav'
  end

  def errors_for(record)
    content_tag :ul, class: 'record-error' do 
      result = ""
      record.errors.full_messages.each do |message|
        result += content_tag('li', message, class: 'record-error-field')
      end
      result.html_safe
    end
  end

  def flash_messages
    trans = { 'alert' => 'alert-danger', 'notice' => 'alert alert-success' }

    content_tag :div, class: 'alert-animate' do
      flash.map do |key, value|
        content_tag 'div', value, class: "alert #{trans[key]} alert-body"
      end.join('.').html_safe
    end
  end

  def breadcrumb options=nil
    content_tag(:ul, breadcrumb_str(options), :class => "breadcrumb")
  end

  def breadcrumb_str options
    items = []
    char_sep = "&raquo;".html_safe
    if( !options.nil?  && options.size != 0)
      items <<  content_tag(:li , :class => "active") do
        link_to_home("Home", root_path) + content_tag(:span, char_sep, :class => "divider")
      end
      options.each do |option|
        option.each do |key, value|
          if value
          items << content_tag(:li) do
            link_to(key, value) + content_tag(:span, char_sep, :class => "divider")
          end 
          else
            items << content_tag(:li, key, :class =>"active") 
          end
        end
      end 
    else
      icon = content_tag "i", " ", :class => "icon-user  icon-home"
      items << content_tag(:li, icon + "Home", :class => "active")  
    end
    items.join("").html_safe
  end

  def page_header title, options={},  &block
     content_tag :div,:class => "list-header clearfix" do
        if block_given? 
            content_title = content_tag :div, :class => "left" do
              content_tag(:h3, title, :class => "header-title")
            end

            output = with_output_buffer(&block)
            content_link = content_tag(:div, output, {:class => " right"})
            content_title + content_link
        else
            content_tag :div , :class => "row" do 
               content_tag(:h3, title, :class => "header-title")
            end
        end 
     end
  end

end
