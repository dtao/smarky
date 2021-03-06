module Smarky
  class Element
    def initialize(*args)
      node_or_name, @title = args

      case node_or_name
      when String
        @document = Nokogiri::HTML::Document.new
        @node     = Nokogiri::XML::Node.new(node_or_name, @document)

      else
        @document = node_or_name.document
        @node     = node_or_name
      end
    end

    def title
      @title ||= begin
        first_child = @node.children.first
        first_child && first_child.name =~ /^h[1-6]$/ && first_child.content
      end
    end

    def parent
      @parent ||= Element.new(@node.parent)
    end

    def name
      @node.name
    end

    def name=(value)
      @node.name = value
    end

    def attributes
      @node.attributes
    end

    def []=(attribute, value)
      @node[attribute] = value
    end

    def content
      @node.content
    end

    def children
      @children ||= @node.children.map { |node| Element.new(node) }
    end

    def sections
      @sections ||= @node.css('> section').map { |node| Element.new(node) }
    end

    def add_child(child)
      @node.add_child(child.node)
      dirty!
      child
    end

    def add_next_sibling(sibling)
      @node.add_next_sibling(sibling.node)
      dirty!
      sibling
    end

    def add_section
      add_child(Element.new('section'))
    end

    def to_html(options={})
      node = @node

      if options[:omit_titles]
        node = node.clone
        node.css('h1,h2,h3,h4,h5,h6').each do |child|
          child.remove()
        end
      end

      # Getting nicely indented HTML:
      # http://stackoverflow.com/questions/1898829/how-do-i-pretty-print-html-with-nokogiri
      # This might be a huge mistake?
      node.to_xhtml(:indent => 2, :indent_text => ' ')
    end

    def inner_html
      @node.inner_html
    end

    protected

    def node
      @node
    end

    private

    def dirty!
      @title    = nil
      @parent   = nil
      @children = nil
      @sections = nil
    end
  end
end
