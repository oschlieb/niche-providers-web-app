class AppBuilder < Rails::AppBuilder
  include Thor::Actions
  include Thor::Shell

  def gemfile
    get "https://raw.github.com/jimlambie/niche_providers_template/master/template/Gemfile", "Gemfile"
  end

  def leftovers

    say("*************************************", :green)
    say("Niche Providers Application Generator", :green)
    say("*************************************", :green)

    say("The installation process will:")
    say(" - create and migrate databases (development, test)")
    say(" - create a robots.txt file")
    say(" - create an administrator user")
    say(" - create Heroku applications (staging, production)")
    say("")
    say("Please answer the following questions:")
    say("")
    say(args[0])
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

    # add paperclip settings to application.rb
    @generator.inject_into_file "config/application.rb", :after => "config.assets.version = '1.0'" do
    "
    \n
    # injected by the Niche Providers application generator
    config.paperclip_defaults = {
      :storage => :s3,
      :s3_host_name => 's3-eu-west-1.amazonaws.com',
      :s3_protocol => 'http',
      :s3_credentials => {
        :region => Figaro.env.s3_region,
        :bucket => Figaro.env.s3_bucket,
        :access_key_id => Figaro.env.s3_key,
        :secret_access_key => Figaro.env.s3_secret
      }
    }\n
    
    ActionMailer::Base.default :from => NicheProviders::SiteSetting.find_or_set(:info_email_label, '#{domain_name.titleize} <no-reply@#{domain_name}.co.uk>')
    ActionMailer::Base.default :to => NicheProviders::SiteSetting.find_or_set(:info_email_address, 'info@#{domain_name}.co.uk')

    if Rails.env.production?

      config.action_mailer.default_url_options = { :host => '#{default_domain}' }

      ActionMailer::Base.smtp_settings = {
        :address        => 'smtp.sendgrid.net',
        :port           => '587',
        :authentication => :plain,
        :user_name      => ENV['SENDGRID_USERNAME'],
        :password       => ENV['SENDGRID_PASSWORD'],
        :domain         => 'heroku.com'
      }
      
      ActionMailer::Base.delivery_method = :smtp
    end

    if Rails.env.development?
      config.action_mailer.default_url_options = { :host => 'localhost:3000' }
      config.action_mailer.delivery_method = :letter_opener
      config.action_mailer.smtp_settings = { :address => 'localhost', :port => 1025 }
    end

    "
    
    end

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
Allow: \/
Disallow: \/ratings
Disallow: \/edit_listing
Disallow: \/admin
Disallow: \/users
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
NicheProviders::SiteSetting.find_or_set(:domain_name, "#{domain}")
NicheProviders::SiteSetting.find_or_set(:info_email_address, "info@#{domain_name}.co.uk")
    RUBY

    # Create config files to be used by Figaro and the Heroku application setup
    say("Generating Heroku and application configuration files")
    get "https://raw.github.com/jimlambie/niche_providers_template/master/template/heroku.yml", "config/heroku.yml"
    get "https://raw.github.com/jimlambie/niche_providers_template/master/template/application.yml", "config/application.yml"

    # create databases
    rake "db:create:all"

    # Request config settings from existing Heroku application so they
    # can be copied into the template configuration files from the previous step
    # N.B. The user executing this command must have access to the `niche-providers-template` application
    # on Heroku, owned by James Lambie (jim@parkbenchproject.com)
    rake "niche_providers:config:create"

    # migrate databases
    rake "niche_providers:install:migrations"
    rake "db:migrate"
    rake "niche_providers:app:bootstrap"

    create_heroku = ask("Create the Heroku applications? [y/n]", :red) == 'y'
    if create_heroku
      say("Creating Heroku applications")
      rake "all heroku:create"
    else
      say("Skipping Heroku applications - run 'rake all heroku:create' to generate the applications in the future", :yellow)
    end

    if create_heroku
      say("Addons specified for Niche Provider applications are:", :green)
      say("     - heroku-postgresql:basic for PRODUCTION, heroku-postgresql:dev for STAGING")
      say("     - newrelic:wayne")
      say("     - pgbackups:plus")
      say("     - sendgrid:starter")
      say("")

      install_addons = ask("Install the addons for each Heroku application? [y/n]", :red) == 'y'

      if install_addons
        say("Installing addons", :green)
        rake "all heroku:addons"
      else
        say("Skipping Heroku addons - run 'rake all heroku:addons' to install them in the future", :yellow)
      end
    else
      say("Skipping Heroku addons - run 'rake all heroku:addons' to install them in the future", :yellow)
    end    

    # stylesheet
    @generator.remove_file "app/assets/stylesheets/application.css"
    get "https://raw.github.com/jimlambie/niche_providers_template/master/template/application.css.scss", "app/assets/stylesheets/application.css.scss"
    get "https://raw.github.com/jimlambie/niche_providers_template/master/template/niche_providers_overrides.css.scss", "app/assets/stylesheets/niche_providers_overrides.css.scss"

    say("")
    say("")

    say("Thank you for your patience! Installation is now complete.")
    say("")
    say("What's next?")
    say("1. edit colours and styles in the CSS overrides file 'app/assets/stylesheets/niche_providers_overrides.css.scss'")
    say("2. replace the default logo with your own: copy an image named 'logo.png' to 'app/assets/images'")
    say("3. run `cd #{domain_name}`")
    say("4. run `rake assets:precompile`")
    say("5. run `foreman start`")
    say("6. open your browser at http://localhost:5000")
    say("7. rejoice.")
    say("")
    say("8. Maybe also read the documentation that has opened in your browser. Any questions can be emailed to jim@parkbenchproject.com.")
    say("")

  end
end