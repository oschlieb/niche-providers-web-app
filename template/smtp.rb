
ActionMailer::Base.default :from => NicheProviders::SiteSetting.find_or_set(:info_email_label, '')
ActionMailer::Base.default :to => NicheProviders::SiteSetting.find_or_set(:info_email_address, '')

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

