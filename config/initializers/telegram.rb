# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

Rails.application.config.telegram_updates_controller.session_store = :redis_cache_store, { expires_in: 1.month }

Telegram.bots_config = {
  nuichat: {
    token: ApplicationConfig.nuichat_bot_token,
    username: ApplicationConfig.nuichat_bot_username, # to support commands with mentions (/help@ChatBot)
    id: ApplicationConfig.nuichat_bot_id
  },
  samochat: {
    token: ApplicationConfig.samochat_bot_token,
    username: ApplicationConfig.samochat_bot_username, # to support commands with mentions (/help@ChatBot)
    id: ApplicationConfig.samochat_bot_id
  }
}

if Rails.env.test?
  Telegram.reset_bots
  Telegram::Bot::ClientStub.stub_all!
end
