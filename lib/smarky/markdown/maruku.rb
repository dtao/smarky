require 'maruku'

module Smarky
  module Markdown
    class Maruku
      def render(markdown)
        ::Maruku.new(markdown).to_html
      end
    end
  end
end
