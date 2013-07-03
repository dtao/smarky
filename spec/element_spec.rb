require File.join(File.dirname(__FILE__), 'spec_helper')

describe Smarky::Element do
  let(:result) { Smarky.parse(@input) }

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
    result.sections.map(&:title).should == ['Chapter 1', 'Chapter 2']
  end

  it 'every section also provides access to child sections' do
    result.sections.map { |s| s.sections.map(&:title) }.should == [
      ['Chapter 1, Part 1', 'Chapter 1, Part 2'],
      ['Chapter 2, Part 1', 'Chapter 2, Part 2']
    ]
  end
end
