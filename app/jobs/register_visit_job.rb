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
      visit.update! chat:, registered_at: Time.zone.now if visit.chat.nil?
    end

    save_project_url(visit)
    visitor = visit.visitor
    CreateForumTopicJob.perform_now visitor, visit if visitor.telegram_message_thread_id.nil?
    if visitor.telegram_message_thread_id.present?
      TopicMessageJob.perform_later visitor, "Контакт с #{visit.referrer}" if visitor.project.thread_on_start?
    else
      Bugsnag.notify 'Не удалось отправить регистрационное сообщение о контакте' do |b|
        b.severity = :warn
        b.meta_data = {
          visitor_id: visit.id
        }
      end
    end
  end

  private

  def save_project_url(visit)
    # Первое посещение, можно установить url проекта
    # TODO Убедиться что посетитель это владелец
    return if visit.referrer.blank?

    visit.project.with_lock do
      visit.project.update! url: visit.referrer if visit.project.url.blank?
    end
  end
end
