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

  s.add_dependency "rails", "~> 4.0.1"
  # s.add_dependency "jquery-rails"

  s.add_dependency 'bootstrap-sass', '~> 3.0.2.0'
  s.add_dependency 'ice_cube'
  s.add_dependency 'haml-rails'
  s.add_dependency 'cancan'
  s.add_dependency 'whenever'
  s.add_dependency 'dynamic_form'
  s.add_dependency 'money-rails'
  s.add_dependency 'rubycas-client'
  s.add_dependency "mysql2"
  s.add_development_dependency 'rspec-rails'
  #s.add_development_dependency 'capybara'                    #not used yet
  s.add_development_dependency 'factory_girl_rails'
  
end
