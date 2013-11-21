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
    @generator.gem "niche_providers", :git => "/Users/james/projects/niche_providers"
    #@generator.gem "niche_providers", :git => "git://github.com/jimlambie/niche-providers-engine", :branch => 'master'
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

    create_file "app/assets/stylesheets/bootstrap_and_overrides.css.less",  <<-RUBY
@import "twitter/bootstrap/bootstrap";
body { padding-top: 60px; }
@import "twitter/bootstrap/responsive";

// Set the correct sprite paths
@iconSpritePath: asset-path("twitter/bootstrap/glyphicons-halflings");
@iconWhiteSpritePath: asset-path("twitter/bootstrap/glyphicons-halflings-white");

// Set the Font Awesome (Font Awesome is default. You can disable by commenting below lines)
// Note: If you use asset_path() here, your compiled bootstrap_and_overrides.css will not
//       have the proper paths. So for now we use the absolute path.
@fontAwesomeEotPath: asset-path("fontawesome-webfont.eot");
@fontAwesomeEotPath_iefix: asset-path("fontawesome-webfont.eot#iefix");
@fontAwesomeWoffPath: asset-path("fontawesome-webfont.woff");
@fontAwesomeTtfPath: asset-path("fontawesome-webfont.ttf");
@fontAwesomeSvgPath: asset-path("fontawesome-webfont.svg");

// Font Awesome
@import "fontawesome";

// Glyphicons
//@import "twitter/bootstrap/sprites.less";

// Your custom LESS stylesheets goes here
//
// Since bootstrap was imported above you have access to its mixins which
// you may use and inherit here
//
// If you'd like to override bootstrap's own variables, you can do so here as well
// See http://twitter.github.com/bootstrap/customize.html#variables for their names and documentation
//
// Example:
// @linkColor: #ff0000;

.pagination {
  background: white;
  cursor: default;
  height: 22px;
  a, span, em {
    padding: 0.2em 0.5em;
    display: block;
    float: left;
    margin-right: 1px;
  }
  .disabled {
    display: none;
  }
  .current {
    font-style: normal;
    font-weight: bold;
    background: #2e6ab1;
    color: white;
    border: 1px solid #2e6ab1;
  }
  a {
    text-decoration: none;
    color: #105cb6;
    border: 1px solid #9aafe5;
    &:hover, &:focus {
      color: #000033;
      border-color: #000033;
    }
  }
  .page_info {
    background: #2e6ab1;
    color: white;
    padding: 0.4em 0.6em;
    width: 22em;
    margin-bottom: 0.3em;
    text-align: center;
    b {
      color: #000033;
      background: #2e6ab1 + 60;
      padding: 0.1em 0.25em;
    }
  }
}
    RUBY

    rake "db:create:all"
    rake "niche_providers:install:migrations"
    rake "db:migrate"
    rake "niche_providers:app:bootstrap"

    #rake "db:migrate"
  end
end