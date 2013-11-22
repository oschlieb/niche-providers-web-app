
Niche Providers Application Builder Template
============================================

An application template that creates a new application for the Niche Providers suite.

Dependencies
------------

Before creating a new application, you need to install:

-   The Ruby language (version 1.9.2 minimum)
-   Rails 3.2

Check that appropriate versions of Ruby and Rails are installed in your development environment:

	$ ruby -v
	$ rails -v

Be sure to read the article [Installing Rails](http://railsapps.github.io/installing-rails.html) to make sure your development environment is set up properly.

In addition, it is essential that you read the [Niche Providers Engine README]() file to ensure you have all the engine's required dependencies.


Creating a new Niche Providers Application
------------------------------------------

To use the application builder template:

    $ rails new myapp -d postgresql --skip-test-unit --skip-bundle -b https://raw.github.com/jimlambie/niche_providers_template/master/template.rb

Replace `myapp` with the name of your application, for example `motoring_providers`.

The `$` character indicates a shell prompt; don‘t include it when you run the command.

See the “Troubleshooting” section below if you see errors. In general, you‘ll avoid many problems if you create your application using RVM as described below.

Creating a Starter App Using RVM
--------------------------------

I recommend using “rvm”:https://rvm.io/, the Ruby Version Manager, to manage your Rails versions, as described in the “Installing Rails”:http://railsapps.github.io/installing-rails.html article.

Here‘s how to generate a new Rails application using the Rails Composer tool and RVM:

    $ mkdir myapp
    $ cd myapp
    $ rvm use ruby-2.0.0@myapp --ruby-version --create
    $ gem install rails
    $ rails new . -m https://raw.github.com/RailsApps/rails-composer/master/composer.rb

You can add the `-T` flag to skip Test::Unit files or the `-O` flag to skip Active Record files. Skip Test::Unit if you plan to use RSpec for unit testing. Skip Active Record if you plan to use a NoSQL datastore with an ORM such as Mongoid.

Instead of installing Rails into the global gemset and running `rails new`, we‘ll create a root directory for a new application, create a new gemset, install Rails, and then generate a starter application.

When we create the gemset, the option ”—ruby-version” creates **.ruby-version** and **.ruby-gemset** files in the root directory. RVM recognizes these files in an application‘s root directory and loads the required version of Ruby and the correct gemset whenever you enter the directory.

When we create the gemset, it will be empty (though it inherits use of all the gems in the global gemset). We immediately install Rails. The command `gem install rails` installs the most recent stable release of Rails.

Finally we run `rails new .`. We use the Unix “dot” convention to refer to the current directory. This assigns the name of the directory to the new application.

This approach is different from the way most beginners are taught to create a Rails application. Our approach makes it easy to create a project-specific gemset to avoid clashes between gem versions when using the Rails Composer tool.

Choose a RailsApps Starter Application
--------------------------------------

Use Rails Composer to generate any of the example applications from the “RailsApps project”:http://railsapps.github.io/. You‘ll be able to choose your own project name when you generate the app. Generating the application gives you additional options.

To build the example application, Rails must be installed in your development environment.

#### Rails 3.2 or Rails 4.0

Choices of starter applications will differ depending on whether you are using Rails 4.0 or Rails 3.2.

Here‘s an example:

    $ rails new myapp -m https://raw.github.com/RailsApps/rails-composer/master/composer.rb

The `$` character indicates a shell prompt; don‘t include it when you run the command.

You can use the `-T` flag to skip Test::Unit files or the `-O` flag to skip Active Record files:

    $ rails new myapp -m https://raw.github.com/RailsApps/rails-composer/master/composer.rb -T -O

This creates a new Rails app named `myapp` on your computer. You can use a different name if you wish.

#### Rails 4.0

With Rails 4.0, you‘ll see a prompt:

    question  Install an example application for Rails 4.0?
          1)  Build a RailsApps starter application
          2)  Build a contributed application
          3)  I want to build my own application

Enter “1” to select **Build a RailsApps starter application**. You‘ll see a prompt:

    question  Starter apps for Rails 4.0. More to come.
          1)  learn-rails
          2)  rails-bootstrap

Make your choice. The Rails Composer tool may give you other options (other applications may have been added since these notes were written).

#### Rails 3.2

With Rails 3.2, you‘ll see a prompt:

    question  Install an example application for Rails 3.2?
              1)  I want to build my own application
              2)  membership/subscription/saas
              3)  rails-prelaunch-signup
              4)  rails3-bootstrap-devise-cancan
              5)  rails3-devise-rspec-cucumber
              6)  rails3-mongoid-devise
              7)  rails3-mongoid-omniauth
              8)  rails3-subdomains

None of these Rails 3.2 example applications are available for Rails 4.0.

#### Options

The application generator template will ask you for additional preferences:

     question  Web server for development?
           1)  WEBrick (default)
           2)  Thin
           3)  Unicorn
           4)  Puma
     question  Web server for production?
           1)  Same as development
           2)  Thin
           3)  Unicorn
           4)  Puma
     question  Template engine?
           1)  ERB
           2)  Haml
           3)  Slim
     question  Continuous testing?
           1)  None
           2)  Guard
       extras  Set a robots.txt file to ban spiders? (y/n)
       extras  Use or create a project-specific rvm gemset? (y/n)
       extras  Create a GitHub repository? (y/n)

#### Web Servers

We recommend Thin in development for speed and less noise in the log files.

If you plan to deploy to Heroku, select Thin as your production webserver. Unicorn is recommended by Heroku but configuration is more complex.

#### Template Engine

The example application uses the default “ERB” Rails template engine. Optionally, you can use another template engine, such as Haml or Slim. See instructions for “Haml and Rails”:http://railsapps.github.io/rails-haml.html.

#### Other Choices

If you are a beginner, you won‘t need “continuous testing.” If you like to use “Guard”:https://github.com/guard/guard, you can select it.

Set a robots.txt file to ban spiders if you want to keep your new site out of Google search results.

It is a good idea to use “RVM”:https://rvm.io/, the Ruby Version Manager, and create a project-specific rvm gemset (not available on Windows). See “Installing Rails”:http://railsapps.github.io/installing-rails.html.

If you choose to create a GitHub repository, the generator will prompt you for a GitHub username and password.

Build Your Own Application
--------------------------

If you choose “I want to build my own application,” you will get a wide set of choices.

These options are for experienced developers. Expect to spend time debugging your starter application as not all options are tested or fully supported.

Here‘s an example of what you‘ll see using Rails 4.0:

    question  Install an example application for Rails 4.0?
          1)  Build a RailsApps starter application
          2)  Build a contributed application
          3)  I want to build my own application

        question  Web server for development?
          1)  WEBrick (default)
          2)  Thin
          3)  Unicorn
          4)  Puma

        question  Web server for production?
          1)  Same as development
          2)  Thin
          3)  Unicorn
          4)  Puma

        question  Database used in development?
          1)  SQLite
          2)  PostgreSQL
          3)  MySQL
          4)  MongoDB

        question  Template engine?
          1)  ERB
          2)  Haml
          3)  Slim (experimental)

        question  Unit testing?
          1)  Test::Unit
          2)  RSpec
          3)  MiniTest

        question  Integration testing?
          1)  None
          2)  RSpec with Capybara
          3)  Cucumber with Capybara
          4)  Turnip with Capybara
          5)  MiniTest with Capybara

        question  Continuous testing?
          1)  None
          2)  Guard

        question  Fixture replacement?
          1)  None
          2)  Factory Girl
          3)  Machinist
          4)  Fabrication

        question  Front-end framework?
          1)  None
          2)  Zurb Foundation 4.0
          3)  Twitter Bootstrap 3.0
          4)  Twitter Bootstrap 2.3
          5)  Simple CSS

        question  Add support for sending email?
          1)  None
          2)  Gmail
          3)  SMTP
          4)  SendGrid
          5)  Mandrill

        question  Authentication?
          1)  None
          2)  Devise
          3)  OmniAuth

        question  Devise modules?
          1)  Devise with default modules
          2)  Devise with Confirmable module
          3)  Devise with Confirmable and Invitable modules

        question  Authorization?
          1)  None
          2)  CanCan with Rolify

        question  Use a form builder gem?
          1)  None
          2)  SimpleForm

        question  Install a starter app?
          1)  None
          2)  Home Page
          3)  Home Page, User Accounts
          4)  Home Page, User Accounts, Admin Dashboard

        extras  Add ‘therubyracer’ JavaScript runtime (for Linux users without node.js)? (y/n)
    extras  Set a robots.txt file to ban spiders? (y/n)
    extras  Create a GitHub repository? (y/n)
    extras  Use application.yml file for environment variables? (y/n)
    extras  Reduce assets logger noise during development? (y/n)
    extras  Improve error reporting with ‘better_errors’ during development? (y/n)
    extras  Use or create a project-specific rvm gemset? (y/n)

Run the Application
-------------------

Switch to the application directory to examine and test what you‘ve built.

    $ cd myapp

#### Quick Test

For a “smoke test” to see if everything runs, display a list of Rake tasks.

    $ rake -T

There‘s no need to run `bundle exec rake` instead of `rake` when you are using rvm (see “rvm and bundler integration”:https://rvm.io/integration/bundler/).

#### Start the Web Server

If you‘ve chosen WEBrick or Thin for your web server, can run the app by entering the command:

`$ rails server`

To see your application in action, open a browser window and navigate to “http://localhost:3000/”:http://localhost:3000.

For the Unicorn web server:

`$ unicorn`

See the app at “http://localhost:8080/”:http://localhost:8080.

For the Puma web server:

`$ rails server puma`

See the app at “http://localhost:3000/”:http://localhost:3000.

#### Login

If you‘ve created a version of the application that sets up a default user, log in with:

-   email: user@example.com
-   password: changeme

You should delete or change any pre-configured logins before you deploy your application.

Testing
-------

Some versions of the starter application will contain a suite of RSpec unit tests or Cucumber scenarios and step definitions.

After installing the application, run `rake -T` to check that rake tasks for RSpec and Cucumber are available.

Run `rake spec` to run all RSpec tests.

Run `rake cucumber` (or more simply, `cucumber`) to run all Cucumber scenarios.

Please send the author a message, create an issue, or submit a pull request if you want to contribute improved RSpec or Cucumber files.

Deployment
----------

For easy deployment, use a “platform as a service” provider such as:

-   “Heroku”:http://www.heroku.com/
-   “CloudFoundry”:http://www.cloudfoundry.com/
-   “EngineYard”:http://www.engineyard.com/
-   “OpenShift”:https://openshift.redhat.com/app/

For deployment on Heroku, see the article:

-   “Rails on Heroku”:http://railsapps.github.io/rails-heroku-tutorial.html

Troubleshooting
---------------

Problems? Please check both “issues for the Rails Composer tool”:https://github.com/RailsApps/rails-composer/issues and the “issues for the rails_apps_composer gem”:https://github.com/RailsApps/rails_apps_composer/issues.

You should review the article “Installing Rails”:http://railsapps.github.io/installing-rails.html to make sure you‘ve updated all the components that are required to run Rails successfully.

#### Problems with “Could not be loaded… You have already activated…”

If you get an error like this:

    Your bundle is complete! Use `bundle show [gemname]` to see where a bundled gem is installed.
        composer  Running 'after bundler' callbacks.
    The template [...] could not be loaded.
    Error: You have already activated ..., but your Gemfile requires ....
    Using bundle exec may solve this.

It‘s due to conflicting gem versions. See the article “Rails Error: “You have already activated (…)””:http://railsapps.github.io/rails-error-you-have-already-activated.html.

#### Problems with “Certificate Verify Failed”

Are you getting an error “OpenSSL certificate verify failed” when you try to generate a new Rails app from an application template? See suggestions to resolve the error “Certificate Verify Failed”:http://railsapps.github.io/openssl-certificate-verify-failed.html.

#### Problems with “Segmentation Fault”

If you get a “segfault” when you try `rails new`, try removing and reinstalling rvm.

Application Template Default
----------------------------

The `rails new` command creates a new Rails application. If you want to use the Rails Composer application template for every Rails application you build, you can set options for the `rails new` command in a **.railsrc** file in your home directory. Here‘s how to set up a **.railsrc** file to use the template when you create a new Rails application:

    # ~/.railsrc
    -m https://raw.github.com/RailsApps/rails-composer/master/composer.rb

Documentation and Support
-------------------------

The Rails Composer application template is assembled from recipes supplied by the “rails_apps_composer”:https://github.com/RailsApps/rails_apps_composer gem. See the rails_apps_composer project to understand how the Rails Composer application works.

#### Customizing the Template

If you wish to change the template to generate an app with your own customized options, you can copy and edit the template file. However, it is better to use the “rails_apps_composer”:https://github.com/RailsApps/rails_apps_composer gem to create a new application template. You‘ll find newer versions of the recipes that make up the application template. You may find issues have been identified and (perhaps) fixed. And it will be easier to maintain your application template if you work from the “rails_apps_composer”:https://github.com/RailsApps/rails_apps_composer gem.

#### Writing Recipes

To understand the code in these templates, take a look at “Thor::Actions”:http://rdoc.info/github/wycats/thor/master/Thor/Actions. Your recipes can use any methods provided by “Thor::Actions”:http://rdoc.info/github/wycats/thor/master/Thor/Actions or “Rails::Generators::Actions”:http://railsapi.com/doc/rails-v3.0.3/classes/Rails/Generators/Actions.html. A big thanks to Yehuda Katz for “creating Thor”:http://yehudakatz.com/2008/05/12/by-thors-hammer/.

#### About Rails Application Templates

There is an unfinished Rails Guide on “Rails Application Templates”:https://github.com/rails/rails/blob/master/guides/source/rails_application_templates.md.

Also see:

“Cooking Up A Custom Rails 3 Template (11 Oct 2010) by Andrea Singh”:http://blog.madebydna.com/all/code/2010/10/11/cooking-up-a-custom-rails3-template.html
 “Rails Application Templates (16 Sept 2010) by Collin Schaafsma”:http://quickleft.com/blog/rails-application-templates
 “Application templates in Rails 3 (18 Sept 2009) by Ben Scofield”:http://benscofield.com/2009/09/application-templates-in-rails-3/
 “Railscasts: App Templates in Rails 2.3 (9 Feb 2009) by Ryan Bates”:http://railscasts.com/episodes/148-app-templates-in-rails-2-3
 “Rails templates (4 Dec 2008) by Pratik Naik”:http://m.onkey.org/rails-templates

#### Similar Projects

There are many similar projects:

-   “Rails application template projects”:http://railsapps.github.io/rails-application-templates.html
-   “Rails examples, tutorials, and starter apps”:http://railsapps.github.io/rails-examples-tutorials.html.

#### Issues

Problems? Please check both “issues for the Rails Composer tool”:https://github.com/RailsApps/rails-composer/issues and the “issues for the rails_apps_composer gem”:https://github.com/RailsApps/rails_apps_composer/issues.

#### Where to Get Help

Your best source for help with problems is “Stack Overflow”:http://stackoverflow.com/questions/tagged/ruby-on-rails-3. Your issue may have been encountered and addressed by others.

You can also try “Rails Hotline”:http://www.railshotline.com/, a free telephone hotline for Rails help staffed by volunteers.

Contributing
------------

Please make changes to the “rails_apps_composer”:https://github.com/RailsApps/rails_apps_composer gem rather than changing the Rails Composer application template.

Credits
-------

Daniel Kehoe initiated the “RailsApps project”:https://github.com/RailsApps and created the Rails Composer application template.

Is it useful to you? Follow the project on Twitter:
 ”@rails_apps”:http://twitter.com/rails_apps
 and tweet some praise. I‘d love to know you were helped out by what I‘ve put together.

License
-------

“MIT License”:http://www.opensource.org/licenses/mit-license

Copyright 2012-13 Daniel Kehoe

Useful Links
------------

  Getting Started                                                                             Articles                                                                                      Tutorials
  ------------------------------------------------------------------------------------------- --------------------------------------------------------------------------------------------- -----------------------------------------------------------------------------------------------------------
  “Learn Rails”:http://learn-rails.com/                                                       “Twitter Bootstrap and Rails”:http://railsapps.github.io/twitter-bootstrap-rails.html         “Rails and Bootstrap”:http://railsapps.github.io/rails-bootstrap/
  “Ruby and Rails”:http://railsapps.github.io/ruby-and-rails.html                             “Analytics for Rails”:http://railsapps.github.io/rails-google-analytics.html
  “What is Ruby on Rails?”:http://railsapps.github.io/what-is-ruby-rails.html                 “Heroku and Rails”:http://railsapps.github.io/rails-heroku-tutorial.html                      “Devise with CanCan and Twitter Bootstrap”:https://tutorials.railsapps.org/rails3-bootstrap-devise-cancan
  “Rails Tutorial”:https://tutorials.railsapps.org/rails-tutorial                             “JavaScript and Rails”:http://railsapps.github.io/rails-javascript-include-external.html      “Rails Membership Site with Stripe”:https://tutorials.railsapps.org/rails-stripe-membership-saas
  “Installing Rails”:http://railsapps.github.io/installing-rails.html                         “Rails Environment Variables”:http://railsapps.github.io/rails-environment-variables.html     “Rails Subscription Site with Recurly”:https://tutorials.railsapps.org/rails-recurly-subscription-saas
  “Updating Rails”:http://railsapps.github.io/updating-rails.html                             “Git and Rails”:http://railsapps.github.io/rails-git.html                                     “Startup Prelaunch Signup Application”:http://railsapps.github.io/tutorial-rails-prelaunch-signup.html
  “Rails Composer”:http://railsapps.github.io/rails-composer/                                 “Email and Rails”:http://railsapps.github.io/rails-send-email.html                            “Devise with RSpec and Cucumber”:http://railsapps.github.io/tutorial-rails-devise-rspec-cucumber.html
  “Rails Examples”:http://railsapps.github.io/                                                “Haml and Rails”:http://railsapps.github.io/rails-haml.html                                   “Devise with Mongoid”:http://railsapps.github.io/tutorial-rails-mongoid-devise.html
  “Rails Starter Apps”:http://railsapps.github.io/rails-examples-tutorials.html               “Rails Application Layout”:http://railsapps.github.io/rails-default-application-layout.html   “OmniAuth with Mongoid”:http://railsapps.github.io/tutorial-rails-mongoid-omniauth.html
  “HTML5 Boilerplate for Rails”:http://railsapps.github.io/rails-html5-boilerplate.html       “Subdomains with Devise”:http://railsapps.github.io/tutorial-rails-subdomains.html
  “Example Gemfiles for Rails”:http://railsapps.github.io/rails-3-2-example-gemfile.html
  “Rails Application Templates”:http://railsapps.github.io/rails-application-templates.html

![githalytics.com alpha](https://cruel-carlota.pagodabox.com/9a7ed11e8570e461c585a7afd3722d71 "githalytics.com alpha")
