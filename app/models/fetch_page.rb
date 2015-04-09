class FetchPage

  def self.instance
    @@instance ||= FetchPage.new
    @@instance
  end

  def run(url)
    open(url) { |io| io.read }
  end

  # def clean_content(html)
  #   doc = Nokogiri::HTML(html)
  #   doc.xpath("//script").remove
  #   doc.xpath("//comment()").remove
  #   doc.xpath("//input[type='submit']").remove
  #   doc.xpath("//input[type='hidden']").remove
  #   doc = doc.xpath("//body")

  #   summary_block = doc.search "[text()*='#{@feed_entry.summary}']"
  #   summary_text = content_for(summary_block)
  #   return summary_text if summary_text.present?


  #   summary_block = content_for(doc.xpath("//*[contains(text(), \"#{@feed_entry.summary}\")]"))
  #   return summary_block if summary_block.present?

  #   result = []

  #   doc.search('//text()').each do |node|
  #     text_content = node.inner_text.strip

  #     if text_content.present? && text_content.include?(@feed_entry.summary)
  #       return content_for(node)
  #     else
  #       result << text_content if text_content.present?
  #     end
  #   end
  #   result.join(" ")
  # end

  # def content_for(node)
  #   node.inner_text.strip
  # end

end


