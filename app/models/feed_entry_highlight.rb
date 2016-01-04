class FeedEntryHighlight
  def initialize(search_highlight)
    @search_highlight = search_highlight
  end

  def id
    @search_highlight["_id"]
  end

  def url
    @search_highlight["_source"]["url"]
  end

  def keywords
    @search_highlight["_source"]["keywords"].join(",")
  end

  def title
   if @search_highlight["highlight"] && @search_highlight["highlight"]["title"]
     @search_highlight["highlight"]["title"].first
   elsif @search_highlight["_source"]["title"]
     @search_highlight["_source"]["title"]
   else
     ''
   end
  end

  def summary
   if @search_highlight["highlight"] && @search_highlight["highlight"]["summary"]
     @search_highlight["highlight"]["summary"].first
   else
    @search_highlight["_source"]["summary"]
   end
  end

  def content
    if @search_highlight["highlight"] && @search_highlight["highlight"]["content"]
      @search_highlight["highlight"]["content"].join(", ")
    end
  end

  def description
    return content if content.present?
    return summary if summary.present?
    ""
  end


end