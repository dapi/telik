# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Перенаправляет клиентское сообщение из телеги оператору в группу
#
class ForwardClientMessageJob < ApplicationJob
  queue_as :default

  # message - объект сообщения из телеги который надо форварднуть
  def perform(visitor, message)
    CreateForumTopicJob.perform_now visitor if visitor.telegram_message_thread_id.nil?
    raise Retry, "No telegram_message_thread_id to redirect message for visitors ##{visitor.id}" if visitor.telegram_message_thread_id.blank?

    logger.info "Copy message for #{visitor} with payload #{message}"
    # Может быть и forward
    visitor.project.bot.copy_message(
      chat_id: visitor.project.telegram_group_id || raise("Project ##{visitor.project_id} has no telegram_group_id"),
      message_thread_id: visitor.telegram_message_thread_id || raise("Visitor ##{visitor.id} has no telegram_message_thread_id"),
      from_chat_id: message.dig('chat', 'id'),
      message_id: message.fetch('message_id')
    )
  end
end
