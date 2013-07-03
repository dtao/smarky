require File.join(File.dirname(__FILE__), 'spec_helper')

describe Smarky::Element do
  let(:result) { Smarky.parse(@input) }

  let(:sections) { result.sections }

  describe 'sections' do
    before :each do
      input <<-EOMARKDOWN
        # Chapter 1
        This is chapter 1.
        
        ## Chapter 1, Part 1
        This is part 1 of chapter 1.
        
        ## Chapter 1, Part 2
        This is part 2 of chapter 1.
        
        # Chapter 2
        This is chapter 2.
        
        ## Chapter 2, Part 1
        This is part 1 of chapter 2.
        
        ## Chapter 2, Part 2
        This is part 2 of chapter 2.
      EOMARKDOWN
    end

    it 'provides access to all of its child sections' do
      sections.map(&:title).should == ['Chapter 1', 'Chapter 2']
    end

    it 'every section also provides access to child sections' do
      sections.map { |s| s.sections.map(&:title) }.should == [
        ['Chapter 1, Part 1', 'Chapter 1, Part 2'],
        ['Chapter 2, Part 1', 'Chapter 2, Part 2']
      ]
    end
  end

  describe 'title' do
    it 'is set to the content of the first header element' do
      input <<-EOMARKDOWN
        This is a title
        ===============
        
        Content content content.
      EOMARKDOWN

      sections.first.title.should == 'This is a title'
    end

    it "doesn't have a title if its first child is not a heading" do
      input <<-EOMARKDOWN
        This is some content before the heading.
        
        This is a heading
        =================
        
        This is some content after the heading.
      EOMARKDOWN

      result.title.should be_nil
    end
  end
end
