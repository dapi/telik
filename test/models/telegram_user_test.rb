# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class TelegramUserTest < ActiveSupport::TestCase
  fixtures :telegram_users
  test 'the truth' do
    assert telegram_users(:bob).persisted?
  end
end
