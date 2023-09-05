# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Соглашение добавляет бота в модель проекта
#
module ProjectBot
  extend ActiveSupport::Concern

  included do
    scope :with_bots, -> { where.not bot_token: nil }
    before_create do
      self.bot_id = bot_token.present? ? fetch_bot_id : ApplicationConfig.bot_id
    end

    before_save :set_webhook, if: :bot_token_changed?
  end

  def bot_token_required?
    tariff&.custom_bot_allowed?
  end

  def bot_token=(value)
    @bot = nil
    super value
  end

  def fetch_bot_id
    bot_token.to_s.split(':').first
  end

  def bot(force = false) # rubocop:disable Style/OptionalBooleanParameter
    @bot = nil if force
    @bot ||= bot_token.present? ? custom_bot : Telegram.bot
  end

  def custom_bot
    @custom_bot ||= Telegram::Bot::Client.new(bot_token, bot_username)
  end

  def set_webhook
    custom_bot.set_webhook(url: Rails.application.routes.url_helpers.telegram_custom_webhook_url(bot_id)) if bot_id.present?
  end

  private

  def validate_bot_token
    return if errors[:bot_token].present?

    # {
    # "ok"=>true,
    # "result"=>{
    # "id"=>6177763867,
    # "is_bot"=>true,
    # "first_name"=>"LocalNuiChatBot",
    # "username"=>"LocalNuiChatBot",
    # "can_join_groups"=>true,
    # "can_read_all_group_messages"=>false,
    # "supports_inline_queries"=>false
    # }
    # }
    self.name ||= self.bot_username = custom_bot.get_me.dig('result', 'username')
  rescue Telegram::Bot::NotFound
    errors.add :bot_token, 'Не действующий токен. Проверьте правильность ввода или создайте новый.'
  rescue Telegram::Bot::Error => e
    if e.message.include? 'Unauthorized'
      errors.add :bot_token, 'Не верный токен. Доступа нет.'
    else
      errors.add :bot_token, e.message
    end
  end
end
