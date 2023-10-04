# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class TradeTest < ActiveSupport::TestCase
  fixtures :trades
  test 'the truth' do
    assert trades(:btc_rub_buy_fixed)
  end
end
