class Telegram::WebhookController < Telegram::Bot::UpdatesController
  def start!(*args)
    binding.pry
    respond_with :message, text: args
  end
end

