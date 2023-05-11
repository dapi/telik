# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Контроллер бота общения с посетителем клиентского сайта
#
class Telegram::ClientBot::WebhookController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  use_session!

  def start!(visit_key = nil, *_args)
    if visit_key.blank?
      respond_with :message, text: 'Привет! Ты кто?'
    elsif visit_key.start_with? Visit::TELEGRAM_KEY_PREFIX
      visit = Visit.includes(:visitor).find_by_telegram_key visit_key
      if visit.nil?
        respond_with :message, text: 'Привет! Визит не найден'
      else
        RegisterVisitJob.perform_later(visit:, chat:)
        if visit.visitor.name.present?
          respond_with :message, text: visit.as_json
        else
          save_context :name_for_visitor
          respond_with :message, text: 'Как Вас зовут?'
        end
      end
    else
      respond_with :message, text: 'Привет! Хм..'
    end
  end

  def message(*_args)
    respond_with :message, text: 'Да-да'
  end

  def name_for_visitor(*args)
    name = args.first
    visit.visitor.update!(name:)
    respond_with :message, text: "#{name}, приятно познакомиться!"
  end
end
