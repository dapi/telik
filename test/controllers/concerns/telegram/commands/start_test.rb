# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class TelegramCommandsStart < TelegramControllerTestCase
  test '/start new customer' do
    visit = visits(:yandex)
    dispatch_command 'start', visit.telegram_key
    assert_includes sendMessageText, 'Чем вам помочь'
  end
end
