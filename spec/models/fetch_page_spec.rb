require 'rails_helper'

RSpec.describe FetchPage, type: :model do
  describe ".run" do
    context "when meta tag has charset as utf-8" do
      it "replace the charset to utf-8" do
        result = FetchPage.instance.run("http://edition.cnn.com/2016/08/02/politics/obama-says-trump-unfit-for-presidency/index.html")
        expect(result).to include('utf-8')
      end
    end

    context "when meta tag has charset different from utf-8" do
      it "does not set charset" do
        result = FetchPage.instance.run("http://www.cdc.gov/ecoli/2009/")
        expect(result).to include('utf-8')
      end
    end
  end

  describe ".identify_encoding_type" do
    context "with utf-8 charset" do
      context "when charset is the property of meta tag" do
        it{
          content = <<-EOD
                      <!doctype html>
                      <html class="no-js" lang="en-US">
                        <head>
            	           <meta charset="UTF-8" />
                         <meta name="viewport" content="width=device-width, initial-scale=1"/>
                        <head>
                        <body></body>
                      </html>
                    EOD
          expect(FetchPage.instance.identify_encoding_type(content).downcase).to eq('utf-8')
        }
      end
      context "when charset is the value of property content of meta tag" do
        it{
          content = <<-EOD
                      <!doctype html>
                      <html class="no-js" lang="en-US">
                        <head>
                          <meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type">
                          <meta name="viewport" content="width=device-width, initial-scale=1"/>
                        <head>
                        <body></body>
                      </html>
                    EOD
          expect(FetchPage.instance.identify_encoding_type(content).downcase).to eq('iso-8859-1')
        }
      end
    end

    context "with non-utf-8 charset" do
      context "when charset is the value of property content of meta tag" do
        it{
          content = <<-EOD
                      <!doctype html>
                      <html class="no-js" lang="en-US">
                        <head>
                          <meta name="viewport" content="width=device-width, initial-scale=1"/>
                        <head>
                        <body></body>
                      </html>
                    EOD
          expect(FetchPage.instance.identify_encoding_type(content).downcase).to eq('utf-8')
        }
      end
    end
  end

  describe ".parse_content" do
    context "with utf-8 content" do
      it "return the utf-8 encoded content from their source encoding type" do
        content = <<-EOD
                    <!doctype html>
                    <html class="no-js" lang="en-US">
                      <head>
                        <meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type">
                      <head>
                      <body>
                        Eat ground beef or ground beef patties that have been cooked to a  safe internal temperature of 160° F
                      </body>
                    </html>
                  EOD
          expect(content).to receive(:encode).with('UTF-8', "iso-8859-1", :invalid => :replace).once
          FetchPage.instance.parse_content(content)
      end
    end
    context "with non utf-8 content" do
      it "return content" do
        content = <<-EOD
                    <!doctype html>
                    <html class="no-js" lang="en-US">
                      <head>
                        <meta content="text/html; charset=utf-8" http-equiv="Content-Type">
                      <head>
                      <body>
                        Eat ground beef or ground beef patties that have been cooked to a  safe internal temperature of 160° F
                      </body>
                    </html>
                  EOD
          expect(content).to receive(:encode).exactly(0).times
          FetchPage.instance.parse_content(content)
      end
    end
  end
end
