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
        first_heading = @node.children.first { |node| node.name =~ /^h(\d)$/ }
        first_heading && first_heading.content
      end
    end

    def parent
      @parent ||= Element.new(@node.parent)
    end

    def name
      @node.name
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

    def to_html
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
