# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Связка платежного метода и валюты. Непосредствено эта запись указывается в сделке.
class PaymentMethodCurrency < ApplicationRecord
  belongs_to :payment_method
  belongs_to :currency
  belongs_to :blockchain, optional: true
end
