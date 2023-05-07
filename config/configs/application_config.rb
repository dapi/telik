# frozen_string_literal: true

# Base class for application config classes
class ApplicationConfig < Anyway::Config
  env_prefix :umka
  attr_config(
    host: 'localhost',
    telegram_bot_token: nil,
    telegram_bot_name: nil
  )

  class << self
    # Make it possible to access a singleton config instance
    # via class methods (i.e., without explicitly calling `instance`)
    delegate_missing_to :instance

    private

    # Returns a singleton config instance
    def instance
      @instance ||= new
    end
  end
end
