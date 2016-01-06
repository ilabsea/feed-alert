class HtmlSearch
  def initialize(content)
    @doc = Nokogiri::HTML(Base64.decode64(content["_content"]))
  end

  def highlight(keywords, &block)
    @keywords = keywords
    body = @doc.at_css("body")
    highlight_node(body, &block)
    @doc.to_html
  end

  private
  def highlight_node(node, &block)
    node.children.each do |child|
      if child.name == 'text'
        search_highlight_text_node(child, &block)
      else
        highlight_node(child, &block)
      end
    end
  end

  def search_highlight_text_node(node, &block)
    return if node.text.blank?

    text = node.text
    new_text = StringSearch.instance.set_source(text).replace_keywords(@keywords, &block)
    new_node = @doc.create_element "span"
    new_node.inner_html = new_text
    node.replace(new_node)
  end

end