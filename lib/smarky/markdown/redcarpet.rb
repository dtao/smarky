require 'redcarpet'

module Smarky
  module Markdown
    class Redcarpet
      def initialize
        @markdown = ::Redcarpet::Markdown.new(::Redcarpet::Render::HTML)
      end

      def render(markdown)
        @markdown.render(markdown)
      end
    end
  end
end
