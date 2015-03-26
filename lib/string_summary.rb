class StringSummary
  MAX_WORDS = 50

  def self.instance
    @@instance ||= StringSummary.new()
    @@instance
  end

  def set_source string
    @source = string
    self
  end

  def text(keywords)
    paragraphes = @source.split("\n\n")
    paragraphes.each do |paragraph|
      paragraph.strip!
      summarized_string = summary(paragraph, keywords)
      if(summarized_string.length > 0)
        return summarized_string # paragraph.strip
      end
    end
    raise StringSummaryError, "Could not find any matches"
  end

  def html(keywords)
    paragraphes = @source.split("<p")

    paragraphes.each do |paragraph|
      paragraph.strip!
      summarized_string = summary(paragraph, keywords)
      if(summarized_string.length >0 )

        paragraph += "</p>" if paragraph[-4..-1].downcase != "</p>"
        return "<p #{paragraph}"
      end
    end
    raise StringSummaryError, "Could not find any matches"
  end

  private
  def initialize(string='')
    @source = string
  end

  def summary(string, keywords)
    words = string.split(" ")
    if words.length > MAX_WORDS
      number_chunks = (words.length / MAX_WORDS.to_f).ceil
      number_chunks.times.each do |i|

        from = i*MAX_WORDS
        if(i < number_chunks - 1 )
          to   =  from + MAX_WORDS - 1
        else
          to = from + ( words.length - (number_chunks -1) * MAX_WORDS ) -1
        end

        chunks = words[from..to]
        search_string = chunks.join(" ")

        return search_string if test(search_string, keywords)
      end
    else
      return string if test(string, keywords)
    end
    ''
  end

  def test(string, keywords)
    string.present? && StringSearch.instance.set_source(string).match_keywords?(keywords)
  end

end