# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  fixtures :currencies
  test 'rub' do
    assert currencies(:rub).fiat?
  end
  test 'btc' do
    assert currencies(:btc).coin?
  end
end
