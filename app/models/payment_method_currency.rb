class PaymentMethodCurrency < ApplicationRecord
  belongs_to :payment_method
  belongs_to :currency
  belongs_to :blockchain, optional: true
end
