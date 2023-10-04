# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Сделка по предложению
class Trade < ApplicationRecord
  include History
  include TradeStateMachine

  belongs_to :advert
  belongs_to :taker, class_name: 'User'

  belongs_to :good_currency, class_name: 'Currency'
  belongs_to :payment_currency, class_name: 'Currency'
  belongs_to :comission_currency, class_name: 'Currency'

  validates :comission_amount, numericality: { greater_than_or_equal_to: 0 }

  # Сколько товара мы покупаем/продаем
  #
  validates :amount, numericality: { greater_than: 0 }

  # Сколько заплатили
  validates :payment_amount, numericality: { greater_than: 0 }
end
