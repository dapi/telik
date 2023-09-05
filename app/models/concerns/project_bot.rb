# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Соглашение добавляет бота в модель проекта
#
module ProjectBot
  extend ActiveSupport::Concern

  included do
    scope :with_bots, -> { where.not bot_token: nil }
  end

  def bot_token_required?
    tariff&.custom_bot_allowed?
  end

  def bot_token=(value)
    @bot = nil
    super value
  end

  def bot_id
    bot_token.to_s.split(':').first
  end

  def bot(force = false) # rubocop:disable Style/OptionalBooleanParameter
    @bot = nil if force
    @bot ||= if bot_token.present?
               Telegram::Bot::Client.new(bot_token, bot_username)
             else
               Telegram.bot
             end
  end
end
