# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Отправляет сообщение посетителю
#
class ClientMessageJob < ApplicationJob
  queue_as :default

  def perform(visitor, message)
    raise 'Visitor has no telegram_id' if visitor.telegram_id.nil?

    Telegram.bots[:client].send_message(
      chat_id: visitor.telegram_id,
      text: message
    )
  end
end
