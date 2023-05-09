class Telegram::SupportBot::WebhookController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  use_session!

  def start!(visit_key = nil, *args)
    if visit_key.blank?
      respond_with :message, text: 'Привет! Ты кто?'
    elsif visit_key.start_with? Visit::TELEGRAM_KEY_PREFIX
      visit = Visit.includes(:visitor).find_by_key(visit_key.sub(Visit::TELEGRAM_KEY_PREFIX,''))
      if visit.nil?
        respond_with :message, text: 'Привет! Визит не найден'
      else
        RegisterNewVisit.new(visit).perform
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

  def message(*args)
    respond_with :message, text: 'Да-да'
  end

  def name_for_visitor(*args)
    name = args.first
    visit.visitor.update! name: name
    respond_with :message, text: "#{name}, приятно познакомиться!"
  end
end

