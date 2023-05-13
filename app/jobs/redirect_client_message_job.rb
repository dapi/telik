# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Перенаправляет клиентское сообщение оператору в группу
#
class RedirectClientMessageJob < ApplicationJob
  queue_as :default

  def perform(visitor, message)
    CreateForumTopicJob.perform_now visitor if visitor.telegram_message_thread_id.nil?
    if visitor.telegram_message_thread_id.present?
      TopicMessageJob.perform_later visitor, visitor.name + ': ' + message
    else
      raise Retry, "No telegram_message_thread_id to redirect message for visitors ##{visitor.id}"
    end
  end
end
