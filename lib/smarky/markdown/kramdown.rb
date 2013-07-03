require 'kramdown'

module Smarky
  module Markdown
    class Kramdown
      def render(markdown)
        ::Kramdown::Document.new(markdown).to_html
      end
    end
  end
end
