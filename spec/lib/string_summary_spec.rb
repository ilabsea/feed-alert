require 'rails_helper'

describe StringSummary do
  describe 'html' do
    context 'keywords found' do
      it "return summary section of html" do
        html = <<-eos
            <p style='font-size: 10;'>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla   pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum</p>.
         eos

         string_summary = StringSummary.instance.set_source(html)
         result = string_summary.html(["adipisicing","reprehenderit"])

         expect(result).to eq "<p style='font-size: 10;'>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>"
      end

      it "handle nested tag" do
        html = <<-eos
          <p class='main'>
            <h1>Main Paragraph</h1>
            this is awesome
            <p class='sub'>
              <h2> Hola otra vez </h2>
              Socio mira eso
              <p>Just an empty one</p>
            </p>

          </p>
        eos

        string_summary = StringSummary.instance.set_source(html)
        result = string_summary.html(['Main', 'empty'])
        expect(result).to eq "<p class='main'>\n            <h1>Main Paragraph</h1>\n            this is awesome</p>"
      end
    end

    context 'load long content' do
      it 'return summary sectionxx' do
        keywords = ["influenza","healthcare","virus","preventive",'aid' ,"behavior","sex","hygiene","education","west"]
        file = File.join(Rails.root, 'spec', 'files', 'html.txt')
        html = File.read(file)
        string_summary = StringSummary.instance.set_source(html)
        result = string_summary.text(keywords)
      end
    end

    context "keywords not found" do
      it "raise expection" do
        string = <<-eos
            Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor 
            incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud 
            exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
         eos

         string_summary = StringSummary.instance.set_source(string)
         expect{string_summary.html("reprehenderitesor")}.to raise_error(StringSummaryError)
      end
    end

  end

  describe 'text' do
    context 'keywords found' do
      it 'return summary section of the text' do
         string = <<-eos
            Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor 
            incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud 
            exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 

            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla 
            pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia
            deserunt mollit anim id est laborum.
         eos

         string_summary = StringSummary.instance.set_source(string)
         result = string_summary.text(["reprehenderit", "proident"])
         expect(result).to eq "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla \n            pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia\n            deserunt mollit anim id est laborum."
      end
    end

    context 'keywords not found' do
      it 'raise exception' do
        string = <<-eos
            Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor 
            incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud 
            exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 

            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla 
            pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia
            deserunt mollit anim id est laborum.
         eos

         string_summary = StringSummary.instance.set_source(string)
         expect{string_summary.text("reprehenderitesor")}.to raise_error(StringSummaryError)
      end

    end
  end
end