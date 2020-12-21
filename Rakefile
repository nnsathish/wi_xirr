require "rake/extensiontask"
spec = Gem::Specification.load('wi_xirr.gemspec')

Rake::ExtensionTask.new('wi_xirr') do |ext|
  ext.lib_dir = 'lib/wi_xirr'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => [:compile, :spec]
