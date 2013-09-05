require 'redcarpet'
require 'smarky'
require 'rspec'
require 'heredoc_unindent'

def input(markdown)
  @input = markdown.unindent
end

def node_to_array(node, options={})
  options ||= {}

  array = [node.name.to_sym]

  if options[:include_attributes] && node.attributes.any?
    array << attribute_hash(node.attributes)
  end

  if node.children.empty?
    array << node.content

  elsif node.children.length == 1 && node.children[0].name == 'text'
    array << node.children[0].content

  else
    node.children.each do |node|
      array << node_to_array(node, options) unless node.name == 'text' && node.content =~ /^\s*$/
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

  def verify_result(*args)
    # Allow expected HTML to be specified either as a last parameter or via a block.
    expected, options = block_given? && [yield, args.pop] || [args.pop, args.pop]

    options ||= {}
    @parse_options = options[:parse_options]
    array_options  = options[:array_options]
    html_options   = options[:html_options]

    case expected
    when Array
      node_to_array(result, array_options)[1..-1].should == expected
    when String
      result.to_html(html_options || {}).should == expected.unindent.strip
    else
      raise "Unable to verify against a #{expected.class}."
    end
  end
end
