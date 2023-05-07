class Telegram::OperatorBot::WebhookController < Telegram::Bot::UpdatesController
  def start!(*args)
    respond_with :message, text: 'Привет, оператор!'
  end

  def message!(*args)
    respond_with :message, text: 'Да-да'
  end
end
