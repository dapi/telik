# frozen_string_literal: true

# Регистрирует новый визит (когда пользователь нажал start)
# А именно:
# 1. Создает если необходимо новый топик
# 2. Уведомлеят оператора о новом нопике
#
class RegisterNewVisit < ApplicationService
  def initialize(visit:, chat:)
    @visit = visit
    @chat = chat
  end

  def perform
    register_visit! @visit, @chat
    FindOrCreateTopic.new(@visit).perform
    notify_operators! @visit
    notify_topic! @visit
  end

  private

  def register_visit!(visit, chat)
    return if visit.registered_at?

    visit.visitor.update_user_from_chat! chat
    visit.update! chat:, registered_at: Time.zone.now
  end

  # Уведомляет оператора о новом посетителе
  def notify_operators!(visit)
    visit.project.memberships.join(:user).pluck(:telegram_id).find_each do |telegram_id|
      # TODO: Кидать ссылку на топик
      Telegram.bots[:operator].send_message chat_id: telegram_id, text: "Новый контакт #{visit.visitor.topic_title}"
    end
  end

  # Отправляет в новый топик уведомление
  def notify_topic!(visit)
    Telegram.bots[:operator].send_message(
      chat_id: visit.project.telegram_group_id,
      message_thread_id: visit.visitor.telegram_message_thread_id,
      text: "Новый поситетиль #{visit.topic_title}"
    )
  end
end
