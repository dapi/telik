# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

if Rails.env.test?
  Rails.application.routes.default_url_options =
    Rails.application.config.action_controller.default_url_options =
    Rails.application.config.action_mailer.default_url_options =
    {
      host: 'www.example.com',
    }
else
  Rails.application.routes.default_url_options =
    Rails.application.config.action_controller.default_url_options =
    Rails.application.config.action_mailer.default_url_options =
    {
      host: ApplicationConfig.host,
      protocol: ApplicationConfig.protocol
    }
end
