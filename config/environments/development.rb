# frozen_string_literal: true
ProcessTracking::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local = true

  config.action_controller.perform_caching = false
  config.eager_load = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :raise

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.serve_static_files = true

  config.admin_email = 'example@example.com'

  # https://github.com/sanger/wrangler
  config.wrangler_url = 'http://127.0.0.1:5000/wrangle'

  # https://github.com/sanger/lighthouse
  config.lighthouse_host = 'http://127.0.0.1:5000'

  config.logger = Logger.new(STDOUT)
end
