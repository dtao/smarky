require 'smarky/element'
require 'smarky/version'
require 'nokogiri'
require 'redcarpet'

module Smarky
  def self.parse(markdown)
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    html     = renderer.render(markdown)
    fragment = Nokogiri::HTML.fragment(html)

    article  = Element.new('article')
    section  = article
    current_level = nil

    fragment.children.each do |node|
      if (heading = node.name.match(/^h(\d)$/i))
        new_section = Element.new('section', heading[0])
        new_section.add_child(Element.new(node))

        level = heading[1].to_i
        if current_level.nil? || level > current_level
          difference = level - (current_level || 0)
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

    article
  end
end
