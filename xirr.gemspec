Gem::Specification.new "xirr", "1.0" do |s|
  s.name = "xirr"
  s.authors = 'Weinvest'
  s.version = 1.0
  s.summary = "Implementation of XIRR in C"
  s.files = Dir.glob("ext/**/*.{c,rb}") + Dir.glob("lib/**/*.rb")
  s.extensions << "ext/xirr/extconf.rb"
  s.add_development_dependency "rake-compiler"
end
