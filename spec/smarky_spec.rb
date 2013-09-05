require File.join(File.dirname(__FILE__), 'spec_helper')

describe Smarky do
  let(:result) { Smarky.parse(@input, @parse_options || {}) }

  describe 'parse' do
    it 'returns a Smarky::Element wrapper around an <article>' do
      result.should be_a(Smarky::Element)
      result.name.should == 'article'
    end

    it 'works in the simplest case: rendering a single paragraph' do
      input 'Why *hello* there.'

      verify_result <<-EOHTML
        <article>
          <p>Why <em>hello</em> there.</p>
        </article>
      EOHTML
    end

    it 'uses RedCarpet for rendering Markdown by default' do
      input <<-EOMARKDOWN
        This should look weird.
        {: .weird }
      EOMARKDOWN

      verify_result <<-EOHTML
        <article>
          <p>This should look weird.
        {: .weird }</p>
        </article>
      EOHTML
    end

    it 'can use Maruku, if specified' do
      input <<-EOMARKDOWN
        This should look normal.
        {: .normal }
      EOMARKDOWN

      verify_result(:parse_options => { :markdown_renderer => :maruku }) do
        <<-EOHTML
          <article>
            <p class="normal">This should look normal.</p>
          </article>
        EOHTML
      end
    end

    it 'can also use Kramdown' do
      # TODO: Test this properly.
      input <<-EOMARKDOWN
        This should also look normal.
        {: .normal }
      EOMARKDOWN

      verify_result(:parse_options => { :markdown_renderer => :kramdown }) do
        <<-EOHTML
          <article>
            <p class="normal">This should also look normal.</p>
          </article>
        EOHTML
      end
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

      verify_result([
        [:section,
          [:h1, 'Section 1'],
          [:p, 'This is section 1.']
        ],
        [:section,
          [:h1, 'Section 2'],
          [:p, 'This is section 2.']
        ]
      ])
    end

    it 'attaches IDs to HTML sections' do
      input <<-EOMARKDOWN
        Section 1
        =========
        
        Section 2
        =========
      EOMARKDOWN

      verify_result(:array_options => { :include_attributes => true }) do
        [
          [:section, { :id => 'section-1' },
            [:h1, 'Section 1'],
          ],
          [:section, { :id => 'section-2' },
            [:h1, 'Section 2']
          ]
        ]
      end
    end

    it 'adds content directly to the root article if there is only one top-level section' do
      input <<-EOMARKDOWN
        Article
        =======
        
        This is some content.
      EOMARKDOWN

      verify_result [
        [:h1, 'Article'],
        [:p, 'This is some content.']
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
