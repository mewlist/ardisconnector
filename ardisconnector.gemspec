$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ardisconnector/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ardisconnector"
  s.version     = Ardisconnector::VERSION
  s.authors     = ["mewlist"]
  s.email       = ["mewlist@mewlist.com"]
  s.homepage    = ""
  s.summary     = "Disconnect database session on request finished"
  s.description = "Disconnect database session on request finished"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "sqlite3"
end
