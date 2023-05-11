# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

Rails.application.routes.default_url_options =
  Rails.application.config.action_controller.default_url_options =
    Rails.application.config.action_mailer.default_url_options =
      {
        host: ApplicationConfig.host,
        protocol: ApplicationConfig.protocol
      }

# Rails.application.config.action_mailer.default_url_options
# Rails.application.routes.default_url_options
# MyApp::Application.default_url_options
# config.action_controller.default_url_options
# ApplicationController#default_url_options method
