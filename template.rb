class AppBuilder < Rails::AppBuilder
  include Thor::Actions
  include Thor::Shell

  def gemfile

    get "https://raw.github.com/jimlambie/niche_providers_template/master/template/Gemfile", "Gemfile"

    #super
    #create_file "Gemfile"
    #@generator.gem "rails", "3.2.14"
    #@generator.gem "pg"
    #@generator.gem "sass-rails",   "~> 3.2.3", group: [:assets]
    #@generator.gem "coffee-rails", "~> 3.2.1", group: [:assets]
    #@generator.gem "uglifier", ">= 1.0.3", group: [:assets]
    #@generator.gem "jquery-rails"
    #@generator.gem "unicorn"
    #@generator.gem "acts_as_rateable", :git => "git://github.com/jimlambie/acts_as_rateable.git", :branch => "master"
    #@generator.gem "addresslogic", :git => "git://github.com/nathansamson/addresslogic.git"
    #@generator.gem 'exception_notification', :git => "git://github.com/smartinez87/exception_notification.git", :tag => "v3.0.1"
    #@generator.gem "niche_providers", :git => "/Users/james/projects/niche_providers"
    #@generator.gem "niche_providers", :git => "git://github.com/jimlambie/niche-providers-engine", :branch => 'master'
  end

  def leftovers

    say("*************************************", :green)
    say("Niche Providers Application Generator")
    say("*************************************", :green)

    say("The installation process will:")
    say(" - create and migrate databases (development, test)")
    say(" - create a robots.txt file")
    say(" - create an administrator user")
    say(" - create Heroku applications (staging, production)")
    say("")
    say("Please answer the following questions:")
    say("")
    domain_name = ask("What is the name of your application? (e.g. motoring_providers)", :green).underscore
    #name = Rails.application.class.parent_name.underscore
    default_domain = "http://www.#{domain_name}.co.uk"
    domain = ask("What is the domain name for your application? (press ENTER to use #{default_domain})", :green)
    if domain == ""
      domain = default_domain
    end
    say("")

    #development_password = ask("What is the development password").underscore
    #production_password = ask("What is the production password").underscore
    #production_server = ask("What is the production server").underscore

    bundle_command('install')

    database_path = "config/database.yml"
    @generator.remove_file(database_path) 

    create_file database_path,  <<-RUBY
development:
  adapter: postgresql
  encoding: unicode
  pool: 5
  database: #{domain_name}_development

test:
  adapter: postgresql
  encoding: unicode
  pool: 5
  database: #{domain_name}_test
    RUBY

    routes_path = "config/routes.rb"
    @generator.remove_file(routes_path)
    create_file routes_path,  <<-RUBY
#{domain_name.camelize}::Application.routes.draw do
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

    @generator.remove_file "db/seeds.rb"
    create_file "db/seeds.rb", <<-RUBY
NicheProviders::Engine.load_seed
    RUBY

    @generator.remove_file "public/robots.txt"
    create_file "public/robots.txt", <<-RUBY
# See http://www.robotstxt.org/wc/norobots.html for documentation on how to use the robots.txt file
User-Agent: *
Disallow: /
Sitemap: #{domain}/sitemap.xml
    RUBY

    @generator.remove_file "public/index.html"
    @generator.remove_file "public/images/rails.png"
    @generator.remove_file "app/assets/images/rails.png"
    @generator.remove_file "app/views/layouts/application.html.erb"

    # gitignore
    @generator.remove_file ".gitignore"
    get "https://raw.github.com/jimlambie/niche_providers_template/master/template/gitignore", ".gitignore"

    # default settings
    create_file "db/default_settings.rb", <<-RUBY
NicheProviders::SiteSetting.find_or_set(:domain_name, domain)
NicheProviders::SiteSetting.find_or_set(:info_email_address, "info@#{domain_name}.co.uk")
    RUBY


    # create & migrate
    rake "db:create:all"
    rake "niche_providers:install:migrations"
    rake "db:migrate"
    rake "niche_providers:app:bootstrap"

    # Heroku setup
    say("Generating Heroku configuration file")
    get "https://raw.github.com/jimlambie/niche_providers_template/master/template/heroku.yml", "config/heroku.yml"
    rake "niche_providers:heroku:config"

    create_heroku = ask("Create the Heroku applications? [y/n]", :red) == 'y'
    if create_heroku
      say("Creating Heroku applications")
      rake "all heroku:create"
    else
      say("Skipping Heroku applications - run 'rake all heroku:create' to generate the applications in the future")
    end

    if create_heroku
      install_addons = ask("Install the adons for each Heroku application? [y/n]", :red) == 'y'

      if install_addons
        say("Installing addons")
        rake "all heroku:addons"
      else
        say("Skipping Heroku addons - run 'rake all heroku:addons' to install them in the future")
      end
    end    

    # stylesheet
    @generator.remove_file "app/assets/stylesheets/application.css"
    get "https://raw.github.com/jimlambie/niche_providers_template/master/template/application.css.scss", "app/assets/stylesheets/application.css.scss"

    say("")
    say("")

    say("Thank you for your patience! Installation is now complete.")
    say("")
    say("What's next?")
    say("1. edit colours and styles in the file 'app/assets/stylesheets/application.css.scss'")
    say("2. copy an image named 'logo.png' to 'app/assets/images'")
    say("3. run `cd #{domain_name}`")
    say("4. run `rake assets:precompile`")
    say("5. run `foreman start`")
    say("6. open your browser at http://localhost:5000")
    say("7. rejoice.")
    say("")
    say("")

  end
end