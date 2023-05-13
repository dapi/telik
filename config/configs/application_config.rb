# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Base class for application config classes
class ApplicationConfig < Anyway::Config
  TELEGRAM_LINK_PREFIX = 'https://t.me/'
  env_prefix :telik
  attr_config(
    app_title: 'NuiBot',
    host: 'localhost',
    protocol: 'http',
    client_bot_token: '',
    client_bot_username: '',
    operator_bot_token: '',
    operator_bot_username: ''
  )

  class << self
    # Make it possible to access a singleton config instance
    # via class methods (i.e., without explicitly calling `instance`)
    delegate_missing_to :instance

    def client_bot_url
      TELEGRAM_LINK_PREFIX + client_bot_username
    end

    def url
      protocol + '://' + host
    end

    private

    # Returns a singleton config instance
    def instance
      @instance ||= new
    end
  end
end
