# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smarky/version'

Gem::Specification.new do |spec|
  spec.name          = "smarky"
  spec.version       = Smarky::VERSION
  spec.authors       = ["Dan Tao"]
  spec.email         = ["daniel.tao@gmail.com"]
  spec.description   = %q{Smarky creates structure from Markdown}
  spec.summary       = %q{Smarky creates structure from Markdown}
  spec.homepage      = "https://github.com/dtao/smarky"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "heredoc_unindent"
  spec.add_development_dependency "github-markdown"
  spec.add_development_dependency "kramdown"
  spec.add_development_dependency "maruku"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "redcarpet"
  spec.add_development_dependency "rspec"
end
