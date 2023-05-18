# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Отправляет сообщение посетителю
#
class ClientMessageJob < ApplicationJob
  queue_as :default

  def perform(visitor, message)
    raise 'Visitor has no telegram_user_id' if visitor.telegram_user_id.nil?

    visitor.project.bot.send_message(
      chat_id: visitor.telegram_user_id,
      # TODO: Добавить имя оператора
      text: visitor.project.username + ': ' + message
    )
  end
end
