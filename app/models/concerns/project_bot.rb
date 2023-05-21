# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Соглашение добавляет бота в модель проекта
#
module ProjectBot
  extend ActiveSupport::Concern

  included do
    scope :with_bots, -> { where.not bot_token: nil }
    before_validation if: :bot_token_changed? do
      self.bot_username = if bot_token.present?
                            # => {"ok"=>true, "result"=>{"id"=>6177763867, "is_bot"=>true, "first_name"=>"LocalNuiChatBot", "username"=>"LocalNuiChatBot", "can_join_groups"=>true, "can_read_all_group_messages"=>false, "supports_inline_queries"=>false}}
                            bot(true).get_me.dig('result', 'username')
                          end
    end
  end

  def bot_token=(value)
    @bot = nil
    super value
  end

  def bot_id
    bot_token.to_s.split(':').first
  end

  def bot(force: false)
    @bot = nil if force
    @bot ||= if bot_token.present?
               Telegram::Bot::Client.new(bot_token, bot_username)
             else
               Telegram.bot
             end
  end
end
