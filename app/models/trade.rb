# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Сделка по предложению
class Trade < ApplicationRecord
  extend Monetizer
  include History
  include TradeStateMachine

  belongs_to :advert
  belongs_to :taker, class_name: 'User'

  belongs_to :good_currency, class_name: 'Currency'
  belongs_to :transfer_currency, class_name: 'Currency'

  validates :comission_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :client_transfer_amount, numericality: { greater_than: 0 }
  validates :total_transfer_amount, numericality: { greater_than: 0 }

  # Сколько товара мы покупаем/продаем
  #
  validates :good_amount, numericality: { greater_than: 0 }

  monetize :good, value: :good_amount, currency: :good_currency
  monetize :comission, value: :comission_amount, currency: :transfer_currency
  monetize :client_transfer, value: :client_transfer_amount, currency: :transfer_currency
  monetize :total_transfer, value: :total_transfer_amount, currency: :transfer_currency

  before_save do
    raise 'WTF' unless total_transfer_amount == client_transfer_amount + comission_amount
  end
end
