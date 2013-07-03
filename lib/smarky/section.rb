module Smarky
  class Section
    attr_reader :parent

    def initialize(parent=nil)
      @parent   = parent
      @children = []
    end

    def append(child)
      @children << child
    end
  end
end
