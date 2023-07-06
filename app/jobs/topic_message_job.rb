# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Отправляет топик посетителя в операторской гуппе сообщение
#
class TopicMessageJob < ApplicationJob
  queue_as :default

  def perform(visitor, message)
    visitor.project.bot.send_message(
      chat_id: visitor.project.telegram_group_id || raise("Project ##{visitor.project_id} has no telegram_group_id"),
      message_thread_id: visitor.telegram_message_thread_id || raise("Visitor ##{visitor.id} has no telegram_message_thread_id"),
      text: message
    )
    # Telegram::Bot::Error: Bad Request: Bad Request: message thread not found
  rescue Telegram::Bot::Error => e
    if e.message.include? 'message thread not found'
      Rails.logger.error e
      Bugsnag.notify e
      visitor.update! telegram_message_thread_id: nil

      # Too Many Requests: Too Many Requests: retry after 42
    elsif e.message.include? 'Too Many Requests'
      timeout = e.message.split.last.to_i
      self.class.set(wait: (timeout + rand(1..50)).seconds).perform_later(visitor, message)
    else
      Rails.logger.error e
      Bugsnag.notify e
      raise e
    end

    # Telegram::Bot::Forbidden (Forbidden: bot was kicked from the supergroup chat)
  rescue Telegram::Bot::Forbidden => e
    Bugsnag.notify e
    Rails.logger.error e
    OperatorMessageJob.perform_later(visitor.project, "У меня нет доступа к группе #{visitor.project.telegram_group_id} (#{e.message})")
    visitor.projects.update! last_error: e.message, last_error_at: Time.zone.now
  end
end
