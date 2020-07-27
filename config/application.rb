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

    if Rails.application.credentials.sendgrid_smtp.present?
      user_mame = Rails.application.credentials.sendgrid_smtp[:user_name]
      password = Rails.application.credentials.sendgrid_smtp[:password]
    else
      user_name = 'user_name'
      password = 'password'
    end

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      user_name: 'apikey',
      password: password,
      domain: 'www.ticket-rec.com',
      address: 'smtp.sendgrid.net',
      port: 587,
      authentication: :plain,
      enable_starttls_auto: true
    }
  end
end
