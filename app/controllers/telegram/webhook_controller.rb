# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Telegram
  # Контроллер обрабатывающий запросы с телеги
  class WebhookController < Bot::UpdatesController
    include Commands::Start
    include Actions::Message
    include Telegram::RescueErrors

    use_session!

    private

    def telegram_user
      @telegram_user ||= TelegramUser
        .create_with(chat.slice(*%w[first_name last_name username]))
        .create_or_find_by! id: chat.fetch('id')
    end

    def direct_client_message?
      from['id'] == chat['id'] && !from['is_bot'] && chat['type'] == 'private'
    end
  end
end
