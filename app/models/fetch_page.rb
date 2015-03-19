class FetchPage
  def initialize(url)
    @url = url
  end

  def run()
    doc = Nokogiri::HTML(open(@url))
    result = []
    content = doc.search('//body//text()').each do |node|
      node_text = node.text.strip
      result << node_text unless node_text.blank?
    end
    result.join()
  end

end