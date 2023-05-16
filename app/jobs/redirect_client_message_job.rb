# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Перенаправляет клиентское сообщение из телеги оператору в группу
#
class RedirectClientMessageJob < ApplicationJob
  queue_as :default

  def perform(visitor, message)
    CreateForumTopicJob.perform_now visitor if visitor.telegram_message_thread_id.nil?
    raise Retry, "No telegram_message_thread_id to redirect message for visitors ##{visitor.id}" if visitor.telegram_message_thread_id.blank?

    TopicMessageJob.perform_later visitor, visitor.name + ': ' + message
  end
end
