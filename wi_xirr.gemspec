$:.push File.expand_path("lib", __dir__)
require "wi_xirr/version"

Gem::Specification.new "wi_xirr" do |s|
  s.name = "wi_xirr"
  s.authors = 'Weinvest'
  s.version = WiXirr::VERSION
  s.summary = "Implementation of XIRR in C"
  s.files = Dir.glob("ext/**/*.{c,rb}") + Dir.glob("lib/**/*.rb")
  s.extensions << "ext/wi_xirr/extconf.rb"
  s.add_development_dependency "rake-compiler"
  s.add_development_dependency "rspec"
  s.add_development_dependency "byebug"
end
