module TelegramBotSupport
  extend ActiveSupport::Concern
  included do
    helper_method :telegram_bot_username
  end

  private

  def telegram_bot_username
    ApplicationConfig.bots_config.fetch(request.host).bot_username
  end
end
