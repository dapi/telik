# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Отправляет топик посетителя в операторской гуппе сообщение
#
class TopicMessageJob < ApplicationJob
  queue_as :default

  def perform(visitor, message)
    Telegram.bots[:operator].send_message(
      chat_id: visitor.project.telegram_group_id || raise("Project ##{visitor.project_id} has no telegram_group_id"),
      message_thread_id: visitor.telegram_message_thread_id || raise("Visitor ##{visitor.id} has no telegram_message_thread_id"),
      text: message
    )
    # Telegram::Bot::Error: Bad Request: Bad Request: message thread not found
  rescue Telegram::Bot::Error => e
    raise e unless e.message.include? 'message thread not found'

    visitor.update! telegram_message_thread_id: nil

    # Telegram::Bot::Forbidden (Forbidden: bot was kicked from the supergroup chat)
  rescue Telegram::Bot::Forbidden => e
    Rails.logger.error e
    OperatorMessageJob.perform_later(visitor.project.owner.telegram_id, 'У меня нет доступа к группе')
    visitor.projects.update! last_error: e.message, last_error_at: Time.zone.now
  end
end
