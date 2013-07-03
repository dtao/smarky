require 'smarky'
require 'rspec'
require 'heredoc_unindent'

describe Smarky do
  def input(markdown)
    @input = markdown.unindent
  end

  def node_to_array(node)
    array = [node.name.to_sym]

    if node.children.empty?
      array << node.content

    elsif node.children.length == 1 && node.children[0].name == 'text'
      array << node.children[0].content

    else
      node.children.each do |node|
        array << node_to_array(node) unless node.name == 'text' && node.content =~ /^\s*$/
      end
    end

    array
  end

  def verify_result(expected)
    case expected
    when Array
      node_to_array(result)[1..-1].should == expected
    when String
      result.inner_html.should == expected
    else
      raise 'Unable to verify against a #{expected.class}.'
    end
  end

  let(:result) { Smarky.parse(@input) }

  before :each do
    @input = ''
  end

  describe 'parse' do
    it 'returns an <article> HTML element' do
      result.should be_a(Nokogiri::XML::Node)
      result.name.should == 'article'
    end

    it 'works in the simplest case: rendering a single paragraph' do
      input 'Why *hello* there.'
      verify_result '<p>Why <em>hello</em> there.</p>'
    end

    it 'renders sibling sections for progressive heading elements' do
      input <<-EOMARKDOWN
        Section 1
        =========
        
        This is section 1.
        
        Section 2
        =========
        
        This is section 2.
      EOMARKDOWN

      verify_result [
        [:section,
          [:h1, 'Section 1'],
          [:p, 'This is section 1.']
        ],
        [:section,
          [:h1, 'Section 2'],
          [:p, 'This is section 2.']
        ]
      ]
    end

    it 'renders nested sections for heading elements with descending rank' do
      input <<-EOMARKDOWN
        Section 1
        =========
        
        This is section 1.
        
        Section 1.1
        -----------
        
        This is section 1.1.
        
        ### Section 1.1.1
        
        This is section 1.1.1.
      EOMARKDOWN

      verify_result [
        [:section,
          [:h1, 'Section 1'],
          [:p, 'This is section 1.'],
          [:section,
            [:h2, 'Section 1.1'],
            [:p, 'This is section 1.1.'],
            [:section,
              [:h3, 'Section 1.1.1'],
              [:p, 'This is section 1.1.1.']
            ]
          ]
        ]
      ]
    end

    it 'works properly for multiple sections and subsections' do
      input <<-EOMARKDOWN
        Section 1
        =========
        
        This is section 1.
        
        Section 1.1
        -----------
        
        This is section 1.1.
        
        Section 2
        =========
        
        This is section 2.
        
        Section 2.1
        -----------
        
        This is section 2.1.
      EOMARKDOWN

      verify_result [
        [:section,
          [:h1, 'Section 1'],
          [:p, 'This is section 1.'],
          [:section,
            [:h2, 'Section 1.1'],
            [:p, 'This is section 1.1.']
          ]
        ],
        [:section,
          [:h1, 'Section 2'],
          [:p, 'This is section 2.'],
          [:section,
            [:h2, 'Section 2.1'],
            [:p, 'This is section 2.1.']
          ]
        ]
      ]
    end
  end
end
