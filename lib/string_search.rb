class StringSearch

  def self.instance
    @@instance ||= StringSearch.new
    @@instance
  end

  def set_source(string)
    @source = string
    self
  end

  def replace_keywords keywords, &block
    keywords_use = [*keywords]
    @source.gsub(reg_for_keywords(keywords_use), &block)
  end

  def translate values
    @source.gsub /\{[^\}\}]*\}\}/ do |matched|
      key = matched[2..-3]
      values[key.to_sym] || matched
    end
  end

  def highlight_keywords keywords, &block
    keywords_use = [*keywords]
    @source.gsub(reg_for_keywords(keywords_use), &block)
  end

  def match_keywords?(keywords)
    keywords_use = [*keywords]
    @source.match(reg_for_keywords(keywords_use)) ? true : false
  end

  private
  def initialize(string='')
    @source = string
  end

  def reg_for_keywords(keywords_use)
    keywords_for_reg = keywords_use.join("|")
    Regexp.new(keywords_for_reg, Regexp::IGNORECASE | Regexp::MULTILINE)
  end
end
