# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class AdvertTest < ActiveSupport::TestCase
  fixtures :users, :payment_methods, :payment_method_currencies, :adverts
  test 'the truth' do
    assert adverts(:btc_rub_buy_fluid)
  end
end
