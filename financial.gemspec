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

  s.add_dependency 'tabs_on_rails'
  s.add_dependency 'ice_cube'
  s.add_dependency 'haml'
  s.add_development_dependency "mysql2"
  s.add_development_dependency 'rspec-rails'
  #s.add_development_dependency 'capybara'                    #not used yet
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'dynamic_form'
  s.add_development_dependency 'money-rails'
  s.add_development_dependency 'rubycas-client-rails'#, :git => 'git://github.com/rubycas/rubycas-client-rails.git'
  s.add_development_dependency 'rubycas-client'
end
