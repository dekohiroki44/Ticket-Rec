require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.i18n.default_locale = :ja
    config.time_zone = 'Asia/Tokyo'
    config.action_view.embed_authenticity_token_in_remote_forms = true

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

    if Rails.application.credentials.ses_smtp.present?
      user_mame = Rails.application.credentials.ses_smtp[:user_name]
      password = Rails.application.credentials.ses_smtp[:password]
    else
      user_name = 'user_name'
      password = 'password'
    end

    config.action_mailer.delivery_method = :ses
    config.action_mailer.smtp_settings = {
        enable_starttls_auto: true,
        address: "email-smtp.us-west-2.amazonaws.com",
        port: 587,
        user_name: user_name,
        domain: 'ticket-rec.com',
        password: password,
        authentication: "login"
    }
  end
end
