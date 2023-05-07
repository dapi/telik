class Telegram::SupportBot::WebhookController < Telegram::Bot::UpdatesController
  def start!(visit_key = nil, *args)
    if visit_key.blank?
      respond_with :message, text: 'Привет! Ты кто?'
    elsif visit_key.start_with? Visit::TELEGRAM_KEY_PREFIX
      visit = Visit.find_by_key(visit_key.sub(Visit::TELEGRAM_KEY_PREFIX,''))
      if visit.nil?
        respond_with :message, text: 'Привет! Визит не найден'
      else
        Telegram.bots[:operator].send_message chat_id: 943084337, text: "Новый посетитель #{visit.as_json}"
        respond_with :message, text: visit.as_json
      end
    else
      respond_with :message, text: 'Привет! Хм..'
    end
  end

  def message(*args)
    respond_with :message, text: 'Да-да'
  end
end

