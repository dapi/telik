# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Отправляет сообщение оператору
#
class OperatorMessageJob < ApplicationJob
  queue_as :default

  def perform(telegram_user_id, message)
    if telegram_user_id.is_a? Array
      telegram_user_id.each do |id|
        self.class.perform_later id, message
      end
    else
      Telegram.bot.send_message(
        chat_id: telegram_user_id,
        text: message
      )
    end
  end
end
