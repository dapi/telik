# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

Rails.application.config.telegram_updates_controller.session_store = :redis_cache_store, { expires_in: 1.month }

Telegram.bots_config = {
  default: {
    token: ApplicationConfig.bot_token,
    username: ApplicationConfig.bot_username, # to support commands with mentions (/help@ChatBot)
    id: ApplicationConfig.bot_id
  }
}

if Rails.env.test?
  Telegram.reset_bots
  Telegram::Bot::ClientStub.stub_all!
end
