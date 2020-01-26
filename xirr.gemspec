$:.push File.expand_path("lib", __dir__)
require "xirr/version"

Gem::Specification.new "xirr" do |s|
  s.name = "xirr"
  s.authors = 'Weinvest'
  s.version = Xirr::VERSION
  s.summary = "Implementation of XIRR in C"
  s.files = Dir.glob("ext/**/*.{c,rb}") + Dir.glob("lib/**/*.rb")
  s.extensions << "ext/xirr/extconf.rb"
  s.add_development_dependency "rake-compiler"
end
