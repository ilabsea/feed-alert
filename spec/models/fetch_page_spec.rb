require 'rails_helper'

RSpec.describe FetchPage, :type => :model do
  describe 'run' do
    it 'fetch' do
      content = <<-eos
        <html>
          <script>alert("ddd")</script>
          <!-- Yes do it -->
          <script>alert("ddd")</script>
          <script>alert("ddd")</script>
          <!-- Yes do it -->

          <body>
            <script>alert("ddd")</script>
            <!-- Yes do it -->
            <script>alert("ddd")</script>
            <script>alert("ddd")</script>
            <!-- Yes do it -->

            <button>Search</button>
            <input type='submit' name='Submit' />
            <div style='diplay:none'> Hidden content for search </div>
            my content <div>Your content</div> try hard to do more
            <p> this is another try more and more. this is another try more and more. this is another try more and more. this is another try more and more. this is another try more and more. this is another try more and more. this is another try more and more. this is another try more and more. this is another try more and more. 
            </p>
          </body>
          
        </html>
      eos

      summary = "this is another try"

      Struct.new('FeedEntry', :url, :summary)
      feed_entry = Struct::FeedEntry.new('htt://stuburl', summary)

      fetch_page = FetchPage.new(feed_entry)

      search = "this is another try more and more. this is another try more and more. this is another try more and more. this is another try more and more. this is another try more and more. this is another try more and more. this is another try more and more. this is another try more and more. this is another try more and more."
      
      expect(fetch_page.clean_content(content)).to eq search

    end


  end
end
