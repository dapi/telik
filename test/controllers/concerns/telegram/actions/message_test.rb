# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class TelegramAtcionsMessage < TelegramControllerTestCase
  test 'сообщение от незнакомого пользователя' do
    dispatch TELEGRAM_UPDATES[:message_with_sticker]
    assert_includes sendMessageText, 'не знакомы'
  end
end
