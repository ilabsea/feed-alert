require 'readability'
class ExtractContent

  def self.instance
    @@instance ||= ExtractContent.new
    @@instance
  end

  def run(url)
    source = FetchPage.instance.run(url)
    Readability::Document.new(source).content
  end

end
