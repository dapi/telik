# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Контроллер бота общения с посетителем клиентского сайта
#
class Telegram::ClientBot::WebhookController < Telegram::Bot::UpdatesController
  def start!(visit_key = nil, *_args)
    if visit_key.blank?
      respond_with :message, text: 'Привет! Ты кто?'
    elsif visit_key.start_with? Visit::TELEGRAM_KEY_PREFIX
      visit = Visit.includes(:visitor).find_by_telegram_key visit_key
      if visit.nil?
        respond_with :message, text: 'Привет! Визит не найден'
      else
        RegisterVisitJob.perform_later(visit:, chat:)
        respond_with :message, text: visit.visitor.project.username + ': Привет! Чем вам помочь?'
      end
    else
      respond_with :message, text: 'Привет! Хм..'
    end
  end

  # {"message_id"=>17,
  # "from"=>{"id"=>943084337, "is_bot"=>false, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "language_code"=>"en"},
  # "chat"=>{"id"=>943084337, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "type"=>"private"},
  # "date"=>1683820060,
  # "text"=>"adas"}
  def message(data)
    # TODO: Если это ответ, то посылать в конкретный проект
    visitor = Visitor.order(:last_visit_at).where(telegram_id: from.fetch('id')).last
    if visitor.present?
      RedirectClientMessageJob.perform_later visitor, data.fetch('text')
    else
      respond_with :message, text: 'Ой, а мы с вами не знакомы :*'
    end
  end
end
