require 'rails_helper'

describe HtmlSearch do
  describe 'highlight' do
    it "highlight keywords" do
      content = <<-EOS
        <!DOCTYPE html>
        <html lang="en">
          <body>
            The technology blog for all geeks
            <a href='/technology'> Programming</a>
            <a href='/agile'> Agile practise</a>
            <a href='/tip-best-practise'> Follow Best Practises</a>

            This blog has all the tips in agile development methodology from experienced developer from
            most welknown company.
          </body>
        </html>
      EOS

      result = "<!DOCTYPE html>\n<html lang=\"en\">\n          <body>\n<span>\n            The <em class=\"highlight\">technology</em> blog for all geeks\n            </span><a href=\"/technology\"><span> Programming</span></a>\n            <a href=\"/agile\"><span> <em class=\"highlight\">Agile</em> practise</span></a>\n            <a href=\"/tip-best-practise\"><span> Follow Best Practises</span></a><span>\n\n            This blog has all the tips in <em class=\"highlight\">agile</em> development methodology from experienced developer from\n            most welknown <em class=\"highlight\">company</em>.\n          </span>\n</body>\n        </html>\n"
      html_search = HtmlSearch.new(content)
      new_html = html_search.highlight(['technology', 'agile', 'company']) do |keyword|
        "<em class='highlight'>#{keyword}</em>"
      end
      expect(new_html).to eq result
    end
  end
end
