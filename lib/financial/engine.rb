module Financial
  class Engine < ::Rails::Engine
    isolate_namespace Financial

    #to avoid copy engine migration to main app migration, just tell the main app that there is migration in this engine
    #see: http://pivotallabs.com/leave-your-migrations-in-your-rails-engines/
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    config.autoload_paths += %W(#{config.root}/extras)

    require 'rubygems'
    require 'cancan'
    require 'bootstrap-sass'
    require 'bootstrap-multiselect-rails'
    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
