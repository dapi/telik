# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Base class for application config classes
class ApplicationConfig < Anyway::Config
  TELEGRAM_LINK_PREFIX = 'https://t.me/'
  env_prefix :telik
  attr_config(
    host: 'localhost',
    protocol: 'http',
    nuichat_bot_token: '',
    nuichat_bot_username: '',
    samochat_bot_token: '',
    samochat_bot_username: ''
  )

  class << self
    # Make it possible to access a singleton config instance
    # via class methods (i.e., without explicitly calling `instance`)
    delegate_missing_to :instance

    def samochat_bot_url
      TELEGRAM_LINK_PREFIX + samochat_bot_username
    end

    def samochat_bot_id
      samochat_bot_token.split(':').first
    end

    def nuichat_bot_url
      TELEGRAM_LINK_PREFIX + nuichat_bot_username
    end

    def nuichat_bot_id
      nuichat_bot_token.split(':').first
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
