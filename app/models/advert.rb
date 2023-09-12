class Advert < ApplicationRecord
  belongs_to :user
  belongs_to :sale_method_currency, class_name: 'PaymentMethod'
  belongs_to :buy_method_currency, class_name: 'PaymentMethod'
  has_one :buy_currency, through: :buy_method_currency, source: :currency
  has_one :sell_currency, through: :sell_method_currency, source: :currency
  belongs_to :rate_source
end
