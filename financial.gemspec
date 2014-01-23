$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "financial/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "financial"
  s.version     = Financial::VERSION
  s.authors     = ["Nhut Thai Le"]
  s.email       = ["lnthai2002@yahoo.com"]
  s.homepage    = "http://darkportal.no-ip.info/pas/financial"
  s.summary     = "Budget management"
  s.description = "Track income/expense, calulate investment/mortgage"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'rails', "~> 4.0.1"
  s.add_dependency 'jquery-rails'
  s.add_dependency 'remotipart'                 #allow submit ajax form with multipart
  s.add_dependency 'will_paginate'              #pagination
  s.add_dependency 'calendar_date_select'       #show calendar to user to select

  s.add_dependency 'sass-rails'
  s.add_dependency 'bootstrap-sass', '~> 3.0.2.0'
  s.add_dependency 'ice_cube'
  s.add_dependency 'haml-rails'                  #shorter syntax to code layout
  s.add_dependency 'cancan'
  s.add_dependency 'whenever'
  s.add_dependency 'dynamic_form'
  s.add_dependency 'money-rails'
  s.add_dependency 'rubycas-client'
  s.add_dependency "mysql2"
  s.add_development_dependency 'rspec-rails'
  #s.add_development_dependency 'capybara'       #not used yet
  s.add_development_dependency 'factory_girl_rails'
  
end
