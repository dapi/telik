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
    visit.with_lock do
      visit.update! chat:, registered_at: Time.zone.now
      visit.visitor.with_lock do
        update! last_visit_at: visit.created_at if visit.visitor.last_visit_at.nil? || visit.visitor.last_visit_at < visit.created_at
      end
      if visit.referrer.present?
        visit.project.with_lock do
          visit.project.update! url: visit.referrer if visit.project.url.blank?
        end
      end
    end
    visitor = visit.visitor
    CreateForumTopicJob.perform_now visitor, visit if visitor.telegram_message_thread_id.nil?
    TopicMessageJob.perform_later visitor, "Контакт с #{visit.referrer}" if visitor.telegram_message_thread_id.present?
  end
end
