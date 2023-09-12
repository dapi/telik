class Trade < ApplicationRecord
  belongs_to :advert
  belongs_to :taker, class_name: 'User'
  belongs_to :sell_currency, class_name: 'Currency'
  belongs_to :buy_currency, class_name: 'Currency'
end
