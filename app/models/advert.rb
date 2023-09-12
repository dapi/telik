class Advert < ApplicationRecord
  belongs_to :user
  belongs_to :sell_method_currency, class_name: 'PaymentMethod'
  belongs_to :buy_method_currency, class_name: 'PaymentMethod'
  belongs_to :rate_source, optional: true

  has_one :buy_currency, through: :buy_method_currency, source: :currency
  has_one :sell_currency, through: :sell_method_currency, source: :currency

  has_many :trades
end
