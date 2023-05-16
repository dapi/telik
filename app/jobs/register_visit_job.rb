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
    visit.update! chat:, registered_at: Time.zone.now
    if visit.referrer.present?
      visit.project.with_lock do
        update! url: visit.referrer if visit.project.url.blank?
      end
    end
    CreateForumTopicJob.perform_now visit.visitor, visit if visit.visitor.telegram_message_thread_id.nil?
  end
end
