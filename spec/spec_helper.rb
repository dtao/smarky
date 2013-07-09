require 'smarky'
require 'rspec'
require 'heredoc_unindent'

def input(markdown)
  @input = markdown.unindent
end

def node_to_array(node)
  array = [node.name.to_sym]

  # if node.attributes.any?
  #   array << attribute_hash(node.attributes)
  # end

  if node.children.empty?
    array << node.content

  elsif node.children.length == 1 && node.children[0].name == 'text'
    array << node.children[0].content

  else
    node.children.each do |node|
      array << node_to_array(node) unless node.name == 'text' && node.content =~ /^\s*$/
    end
  end

  array
end

def attribute_hash(attributes)
  attributes.inject({}) do |hash, (name, attribute)|
    hash[name.to_sym] = attribute.content
    hash
  end
end

RSpec.configure do |config|
  config.before :each do
    @input = ''
  end
end
