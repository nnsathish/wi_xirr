$:.push File.expand_path("lib", __dir__)
require "wi_xirr/version"

Gem::Specification.new "wi_xirr" do |s|
  s.name     = "wi_xirr"
  s.authors  = 'Weinvest'
  s.version  = WiXirr::VERSION
  s.summary  = "Implementation of XIRR in C"
  s.homepage = 'https://github.com/planarinvestments/wi_xirr'
  s.license  = 'MIT'

  s.files      = Dir["{lib,ext}/**/*", "LICENSE.txt", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]
  s.extensions << "ext/wi_xirr/extconf.rb"

  s.required_ruby_version = '>= 2.5.0'

  s.add_development_dependency "rake-compiler", '~> 1.0'
  s.add_development_dependency "rspec", '~> 3.9'
  s.add_development_dependency 'bundler', '~> 2.0', '>= 1.17'
  s.add_development_dependency "byebug", '~> 11.0'
end
