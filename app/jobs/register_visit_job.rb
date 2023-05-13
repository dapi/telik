# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Регистрирует новый визит (когда пользователь нажал start)
# А именно:
# 1. Создает если необходимо новый топик
# 2. Уведомлеят оператора о новом нопике
#
class RegisterVisitJob < ApplicationJob
  queue_as :default

  def perform(visit:, chat:)
    visitor.with_lock do
      visit.visitor.update_user_from_chat!(chat || raise('Empty chat data'))
      visit.update! chat:, registered_at: Time.zone.now
    end
    CreateForumTopicJob.perform_now visit.visitor if visitor.telegram_message_thread_id.nil?
  end
end
