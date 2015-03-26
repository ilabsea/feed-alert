require 'rails_helper'

describe StringSearch do
  describe '.replace_keywords' do
    context "keywords found" do
      it 'highlight string that matched' do
        string_search = StringSearch.instance.set_source("This is a serious case for malarias disease outbreak")
        result = string_search.replace_keywords(['serious', 'malarias', 'disease']) { |matched| "<b>#{matched}</b>"}
        expect(result).to eq("This is a <b>serious</b> case for <b>malarias</b> <b>disease</b> outbreak")
      end
    end

    context 'keywords not found' do
      it 'does not highlight anything' do
        string_search = StringSearch.instance.set_source("This is a serious case for malarias disease outbreak")
        result = string_search.replace_keywords('HIV') { |matched| "<b>#{matched}</b>"}
        expect(result).to eq "This is a serious case for malarias disease outbreak"
      end
    end
  end

  describe '.match_keywords?' do
    context "keywords found" do
      it 'return true' do
        string_search = StringSearch.instance.set_source("This is a serious case for malarias disease outbreak")
        result = string_search.match_keywords?(['serious', 'malarias', 'disease'])
        expect(result).to eq true
      end
    end

    context 'keywords not found' do
      it 'return false' do
        string_search = StringSearch.instance.set_source("This is a serious case for malarias disease outbreak")
        result = string_search.match_keywords?('HIV')
        expect(result).to eq false
      end
    end
  end

end