require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Run specs w/ RSpec"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--format=n --color"
end

task :default => :spec
