require 'readability'
class ExtractContent

  def self.instance
    @@instance ||= ExtractContent.new
  end

  def fetch(url)
    source = FetchPage.instance.run(url)
    Readability::Document.new(source).content
  end

end
