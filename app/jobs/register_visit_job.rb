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
    register_visit! visit, chat unless visit.registered_at?
    visitor = visit.visitor
    CreateForumTopicJob.perform_now visitor if visitor.telegram_message_thread_id.nil?
    notify_operators! visit
    TopicMessageJob.perform_later visitor, "Новый посетитель с #{visit.referrer}"
  end

  private

  def register_visit!(visit, chat)
    visit.visitor.update_user_from_chat!(chat || raise('Empty chat data'))
    visit.update! chat:, registered_at: Time.zone.now
  end

  # Уведомляет оператора о новом посетителе
  def notify_operators!(visit)
    visit.project.memberships.joins(:user, :project).pluck(:telegram_id).uniq.each do |telegram_id|
      Telegram.bots[:operator].send_message(
        chat_id: telegram_id,
        text: "Новый контакт #{visit.visitor.topic_title} #{visit.visitor.topic_url}"
      )
    end
  end
end
