require 'open-uri'
require 'open_uri_redirections'

class FetchPage

  def self.instance
    @@instance ||= FetchPage.new
    @@instance
  end

  def content_from(url)
    open(url, allow_redirections: :all) { |io| io.read }
  end

  def complete_url_in_content(url, content)
    doc = Nokogiri::HTML(content)

    doc.search('link,a,img').each do |node|
      attr_name = (node.name == 'img' ? 'src' : 'href')
      node[attr_name] = ( domain(url) + node[attr_name]) if valid_relative_url(node[attr_name])
    end
    doc.to_html
  end

  def run(url)
    content = content_from(url)
    complete_url_in_content(url, content)
  end

  def valid_relative_url(url)
    !url.blank? && !url.include?("//") && !url.start_with?("#")
  end

  def domain(url)
    uri = URI(url)
    "#{uri.scheme}://#{uri.host}"
  end

end


