require 'github/markdown'

module Smarky
  module Markdown
    class GFM
      def render(markdown)
        GitHub::Markdown.render(markdown)
      end
    end
  end
end
