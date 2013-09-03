require 'smarky/element'
require 'smarky/version'
require 'nokogiri'

module Smarky
  def self.parse(markdown, options={})
    html     = self.markdown_renderer(options).render(markdown)
    fragment = Nokogiri::HTML.fragment(html)

    article  = Element.new('article')
    section  = article
    current_level = nil

    fragment.children.each do |node|
      if (heading = node.name.match(/^h(\d)$/i))
        title = node.content

        new_section = Element.new('section', title)
        new_section.add_child(Element.new(node))
        new_section['id'] = title.downcase.gsub(/[^0-9A-Z]/i, '-')

        level = heading[1].to_i
        if current_level.nil? || level > current_level
          difference = level - (current_level || 1)
          while difference > 1
            wrapper_section = Element.new('section')
            section.add_child(wrapper_section)
            section = wrapper_section
            difference -= 1
          end

          section.add_child(new_section)
          section = new_section

        elsif level == current_level
          section.add_next_sibling(new_section)
          section = new_section

        else
          difference = current_level - level
          while difference > 0
            section = section.parent
            difference -= 1
          end

          section.add_next_sibling(new_section)
          section = new_section
        end

        current_level = level

      else
        section.add_child(Element.new(node))
      end
    end

    # Special case: when an <article> contains exactly one <section> and nothing more.
    if article.children.length == 1 && article.sections.length == 1
      only_section = article.sections.first
      only_section.name = 'article'
      return only_section
    end

    article
  end

  def self.markdown_renderer(options={})
    case options[:markdown_renderer]
    when :redcarpet
      require 'smarky/markdown/redcarpet'
      Smarky::Markdown::Redcarpet.new

    when :maruku
      require 'smarky/markdown/maruku'
      Smarky::Markdown::Maruku.new

    when :kramdown
      require 'smarky/markdown/kramdown'
      Smarky::Markdown::Kramdown.new

    else
      # Just use whatever's available.
      if defined?(::Redcarpet)
        require 'smarky/markdown/redcarpet'
        Smarky::Markdown::Redcarpet.new

      elsif defined?(::Kramdown)
      require 'smarky/markdown/kramdown'
        Smarky::Markdown::Kramdown.new

      elsif defined?(::Maruku)
      require 'smarky/markdown/maruku'
        Smarky::Markdown::Maruku.new

      else
        raise "Smarky currently requires Redcarpet, Kramdown, or Maruku!"
      end
    end
  end
end
