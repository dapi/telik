# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class PaymentMethodTest < ActiveSupport::TestCase
  fixtures :payment_methods
  test 'tinkoff persisted' do
    assert payment_methods(:tinkoff)
  end
end
