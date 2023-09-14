# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class PaymentMethodCurrencyTest < ActiveSupport::TestCase
  fixtures :currencies, :payment_method_currencies

  test 'tinkoff_rub' do
    # ActiveRecord::Base.connection.all_foreign_keys_valid?
    assert payment_method_currencies(:tinkoff_rub)
    assert_equal payment_method_currencies(:tinkoff_rub).currency, currencies(:rub)
  end

  test 'blockchain_btc' do
    assert payment_method_currencies(:blockchain_btc)
    assert_equal payment_method_currencies(:blockchain_btc).currency, currencies(:btc)
  end
end
