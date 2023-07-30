# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Отправляет сообщение посетителю от оператора
#
class ForwardOperatorMessageJob < ApplicationJob
  queue_as :default

  def perform(visitor, message)
    raise 'Visitor has no telegram_user_id' if visitor.telegram_user_id.nil?

    visitor.project.bot.copy_message(
      chat_id: visitor.telegram_user_id,
      from_chat_id: message.dig('chat', 'id'),
      message_id: message.fetch('message_id')
    )
  end
end
