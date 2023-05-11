# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

Rails.application.config.telegram_updates_controller.session_store = :redis_cache_store, { expires_in: 1.month }

Telegram.bots_config = {
  # default: DEFAULT_BOT_TOKEN,
  client: {
    token: ApplicationConfig.client_bot_token,
    username: ApplicationConfig.client_bot_username # to support commands with mentions (/help@ChatBot)
  },
  operator: {
    token: ApplicationConfig.operator_bot_token,
    username: ApplicationConfig.operator_bot_username # to support commands with mentions (/help@ChatBot)
  }
}

if Rails.env.test?
  Telegram.reset_bots
  Telegram::Bot::ClientStub.stub_all!
end
