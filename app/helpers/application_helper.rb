module ApplicationHelper
  def index_in_paginate(index)
    page = params[:page].to_i
    offset_page = page > 1 ? page - 1 : 0
    index + Kaminari.config.default_per_page * offset_page
  end
  
  def page_title(title)
    content_for(:title) { title + " - " + ENV['APP_NAME'] }
  end
  
  def paginate_for(records)
    content_tag :div, paginate(records, theme: 'twitter-bootstrap-3'), class: 'paginate-nav'
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

  def flash_config
    config = {key: '', value: ''}
    flash.map do |key, value|
      config[:key] = key
      config[:value] = value
    end
    config
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
    if(!options.blank?)
      items <<  content_tag(:li, link_home("Home", root_path) , :class => "active")
      options.each do |option|
        items << breadcrumb_node(option.first)
      end
    else
      icon = content_tag "i", " ", :class => "icon-user  icon-home"
      items << content_tag(:li, icon + "Home", :class => "active")
    end
    items.join("").html_safe
  end

  def breadcrumb_node option
    key = option[0]
    value = option[1]
    value ? content_tag(:li){ link_to(key, value)} : content_tag(:li, key, :class =>"active")
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
            content_tag :div , :class => "" do 
               content_tag(:h3, title, :class => "header-title")
            end
        end 
     end
  end


  def sms_template_params_for selector
    template_params = %w(alert_name total_match keywords)
    template_params_selector template_params, selector
  end

  def boolean_text state
    if state
      text = "Yes"
      klass = 'label-primary'
    else
      text = "No"
      klass = "label-danger"
    end
    content_tag :span, text, class: "bool-text label #{klass}"
  end

  def template_params_selector template_params, selector
    template_params.map do |anchor|
      link_to("{{#{anchor}}}", 'javascript:void(0)', data: {selector: selector}, class: 'param-link')
    end.join(", ").html_safe
  end

  def link_destroy value , url, options={}, &block
    options ||= {}
    options[:title] ||= "Delete"
    link_icon "glyphicon-trash", value, url, options, &block
  end

  def link_edit value , url, options={}, &block
    options ||= {}
    options[:title] ||= "Edit"
    link_icon "glyphicon glyphicon-edit", value, url, options, &block
  end

  def link_new value , url, options={}, &block
    options[:class] = "btn-icon btn btn-primary btn-app #{options[:class]}"

    link_icon "glyphicon-plus", value, url, options, &block
  end

  def link_custom value, url, options={}, &block
    options[:class] = "btn-icon btn btn-primary btn-app #{options[:class]}"
    link_to value, url, options, &block
  end

  def link_icon icon, value, url, options={}, &block
    options ||= {}
    options[:class] = "btn-icon #{options[:class]}"
    icon = content_tag :i, ' ',  class: "#{icon} glyphicon"
    text = content_tag :span, " #{value}"
    link_to icon+text, url, options, &block
  end

  def app_menu name
    if !user_signed_in?
      menu = [
           {controller: '', text: '', url: root_path, class: 'before'},
           {controller: :home, text: 'Home', url: root_path, class: 'active'},
           {controller: '', text: '', url: root_path, class: 'after'},

         ]
      return menu
    end

    menu = [
           {controller: :home, text: 'Home', url: root_path, class: ''},
           { controller: [:alerts, :feed_entries], text: 'Alerts', url: alerts_path, class: '' },
           { controller: :members, text: 'Members', url: members_path, class: '' },
           { controller: :groups, text: 'Groups', url: groups_path, class: '' },
           { controller: :users, text: 'Users' ,url: users_path, class: '' }
    ]


    index = 0
    index_first = 0
    index_last = menu.size - 1

    menu.each_with_index do |item, i|
      menu_controller = (item[:controller].class == Array ) ? item[:controller] : [item[:controller]]
      if menu_controller.include?(name.to_sym)
        index = i
        break
      end
    end
    
    if index == index_first
      menu[index][:class] = :active
      menu[index+1][:class] = :after
      menu.unshift({text: '', class: :before })

    elsif index == index_last
      menu[index-1][:class] = :before
      menu[index][:class] = :active
      menu.append({text: '', class: :after})
    else
      menu[index-1][:class] = :before
      menu[index][:class] = :active
      menu[index+1][:class] = :after
    end
    menu
  end

  def data_as_url datas
    "data:text/html;charset=utf-8," + u(datas)
  end

  def highlight_search result
    "<em class='highlight' style='background:yellow;'><b>#{result}</b></em>"
  end

  def alert_time alert
    results = []
    results << "from #{alert.from_time}" unless alert.from_time.blank?
    results << "to #{alert.to_time}" unless alert.to_time.blank?
    results.join(", ")
  end
end
