$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "financial/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "financial"
  s.version     = Financial::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Financial."
  s.description = "TODO: Description of Financial."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.13"
  # s.add_dependency "jquery-rails"

  s.add_dependency 'haml'
  s.add_development_dependency "mysql2"
  s.add_development_dependency 'rspec-rails'
  #s.add_development_dependency 'capybara'                    #not used yet
  s.add_development_dependency 'factory_girl_rails'
end
