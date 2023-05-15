# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Отправляет сообщение оператору
#
class OperatorMessageJob < ApplicationJob
  queue_as :default

  def perform(telegram_id, message)
    if telegram_id.is_a? Array
      telegram_id.each do |id|
        self.class.perform_later id, message
      end
    else
      Telegram.bot.send_message(
        chat_id: telegram_id,
        text: message
      )
    end
  end
end
