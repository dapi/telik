# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class HistoryTest < ActiveSupport::TestCase
  fixtures :trades
  setup do
    @trade = trades(:btc_rub_buy_fluid)
  end

  test 'saves history' do
    assert @trade.history.empty?
    @trade.accept!
    assert @trade.history.any?
  end
end
