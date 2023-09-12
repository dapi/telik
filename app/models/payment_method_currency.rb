# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

class PaymentMethodCurrency < ApplicationRecord
  belongs_to :payment_method
  belongs_to :currency
  belongs_to :blockchain, optional: true
end
