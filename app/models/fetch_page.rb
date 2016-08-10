require 'open-uri'
require 'open_uri_redirections'

class FetchPage

  attr_accessor :encoding_type

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

    build_html_doc_encoding(doc) unless proper_encoding?
    doc.to_html
  end

  def build_html_doc_encoding doc
    doc.search('meta').each do |node|
      if node['charset']
        node['charset'] = 'utf-8'
        break
      end

      if node['content']
        charsets = node['content'].split("text/html; charset=")
        if charsets.length > 1
          node['content'] = "text/html; charset=utf-8"
          break
        end
      end
    end

    doc
  end

  def proper_encoding?
    @encoding_type.downcase == 'utf-8'
  end

  def parse_content content
    @encoding_type = identify_encoding_type(content)
    proper_encoding? ? content : content.encode('UTF-8', @encoding_type, :invalid => :replace)
  end

  def identify_encoding_type content
    doc = Nokogiri::HTML(content)
    encoding_type = 'utf-8'
    doc.search('meta').each do |node|
      # if charset contains inside <meta charset="utf-8" />
      if node['charset']
        return node['charset']
      end
      # if charset contains inside <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      if node['content']
        charsets = node['content'].split("charset=")
        if charsets.length > 1
          return charsets[1]
        end
      end
    end
    encoding_type
  end

  def run(url)
    content = content_from(url)
    content = self.parse_content(content)
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
