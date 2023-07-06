# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Отправляет сообщение оператору
#
class OperatorMessageJob < ApplicationJob
  queue_as :default

  def perform(project, message)
    project.bot.send_message(
      chat_id: project.owner.telegram_user_id,
      text: message
    )
  end
end
