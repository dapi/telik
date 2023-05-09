# frozen_string_literal: true

# Контроллер операторского бота.
#
class Telegram::OperatorBot::WebhookController < Telegram::Bot::UpdatesController
  def start!(*_args)
    respond_with :message, text: 'Привет, оператор!'
  end

  def message!(*_args)
    respond_with :message, text: 'Да-да'
  end
end
