# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/middleware/i18n'

if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.error_handlers << proc { |ex, context| Bugsnag.notify(ex, context) }
    Sidekiq.logger.info("Connection pool #{ActiveRecord::Base.connection.instance_variable_get('@config').fetch(:pool)}")
  end
elsif Rails.env.development?

  require 'sidekiq/testing/inline'
  Sidekiq::Testing.inline!

elsif Rails.env.test?
  require 'sidekiq/testing/inline'
  Sidekiq::Testing.fake!
end
