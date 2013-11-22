class AppBuilder < Rails::AppBuilder
  include Thor::Actions
  include Thor::Shell

  def gemfile
    #super
    create_file "Gemfile"
    @generator.gem "rails", "3.2.14"
    @generator.gem "pg"
    @generator.gem "sass-rails",   "~> 3.2.3", group: [:assets]
    @generator.gem "coffee-rails", "~> 3.2.1", group: [:assets]
    @generator.gem "uglifier", ">= 1.0.3", group: [:assets]
    @generator.gem "jquery-rails"
    @generator.gem "unicorn"
    @generator.gem "acts_as_rateable", :git => "git://github.com/jimlambie/acts_as_rateable.git", :branch => "master"
    @generator.gem "addresslogic", :git => "git://github.com/nathansamson/addresslogic.git"
    @generator.gem 'exception_notification', :git => "git://github.com/smartinez87/exception_notification.git", :tag => "v3.0.1"
    #@generator.gem "niche_providers", :git => "/Users/james/projects/niche_providers"
    @generator.gem "niche_providers", :git => "git://github.com/jimlambie/niche-providers-engine", :branch => 'master'
  end

  def leftovers

    bundle_command('install')

    database_path = "config/database.yml"
    @generator.remove_file(database_path) 

    name = ask("What was the name of your application again? (e.g. motoring_providers)").underscore

    #development_password = ask("What is the development password").underscore
    #production_password = ask("What is the production password").underscore
    #production_server = ask("What is the production server").underscore

    create_file database_path,  <<-RUBY
development:
  adapter: postgresql
  encoding: unicode
  pool: 5
  database: #{name}_development

test:
  adapter: postgresql
  encoding: unicode
  pool: 5
  database: #{name}_test
    RUBY

    routes_path = "config/routes.rb"
    @generator.remove_file(routes_path)
    create_file routes_path,  <<-RUBY
#{name.camelize}::Application.routes.draw do
  mount NicheProviders::Engine, at: "/"
end
    RUBY

    create_file "config/unicorn.rb", <<-RUBY
# config/unicorn.rb
# https://devcenter.heroku.com/articles/rails-unicorn

worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout Integer(ENV['WEB_TIMEOUT'] || 15)
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end 

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
    RUBY

    create_file "Procfile", <<-RUBY
web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
    RUBY

    @generator.remove_file "public/index.html"
    @generator.remove_file "public/images/rails.png"
    @generator.remove_file "app/views/layouts/application.html.erb"

    rake "db:create:all"
    rake "niche_providers:install:migrations"
    rake "db:migrate"
    rake "niche_providers:app:bootstrap"

    #rake "db:migrate"
  end
end