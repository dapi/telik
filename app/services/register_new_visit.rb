# frozen_string_literal: true

# Регистрирует новый визит (когда пользователь нажал start)
# А именно:
# 1. Создает если необходимо новый топик
# 2. Уведомлеят оператора о новом нопике
#
class RegisterNewVisit < ApplicationService
  def initialize(visit)
    @visit = visit
  end

  def perform
    FindOrCreateTopic.new(@visit).perform
    notify_topic! @visit
    notify_operator! @visit
  end

  private

  # Уведомляет оператора о новом посетителе
  def notify_operator!(visit)
    Telegram.bots[:operator].send_message chat_id: 943_084_337, text: "Новый посетитель #{visit.as_json}"
  end

  # Отправляет в новый топик уведомление
  def notify_topic!(visit)
    Telegram.bots[:operator].send_message(
      chat_id: visit.project.telegram_group_id,
      message_thread_id: visit.visitor.telegram_message_thread_id,
      text: "Новый поситетиль #{visit.as_json}"
    )
  end
end
