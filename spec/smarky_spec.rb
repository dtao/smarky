require File.join(File.dirname(__FILE__), 'spec_helper')

describe Smarky do
  include SmarkySpecs

  describe 'parse' do
    def verify_result(expected)
      case expected
      when Array
        node_to_array(result)[1..-1].should == expected
      when String
        result.to_html.should == expected
      else
        raise 'Unable to verify against a #{expected.class}.'
      end
    end

    it 'returns a Smarky::Element wrapper around an <article>' do
      result.should be_a(Smarky::Element)
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

    it 'handles diving down and then jumping back up by multiple levels' do
      input <<-EOMARKDOWN
        # Section 1
        
        This is section 1.
        
        ### Section 1.1.1
        
        This is section 1.1.1.
        
        # Section 2
        
        This is section 2.
      EOMARKDOWN

      verify_result [
        [:section,
          [:h1, 'Section 1'],
          [:p, 'This is section 1.'],
          [:section,
            [:section,
              [:h3, 'Section 1.1.1'],
              [:p, 'This is section 1.1.1.']
            ]
          ]
        ],
        [:section,
          [:h1, 'Section 2'],
          [:p, 'This is section 2.']
        ]
      ]
    end
  end
end
