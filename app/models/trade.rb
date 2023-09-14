# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Сделка по предложению
class Trade < ApplicationRecord
  include History
  include TradeStateMachine

  belongs_to :advert
  belongs_to :taker, class_name: 'User'

  belongs_to :sell_currency, class_name: 'Currency'
  belongs_to :buy_currency, class_name: 'Currency'
  belongs_to :comission_currency, class_name: 'Currency'

  validates :comission_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :sell_amount, numericality: { greater_than: 0 }
  validates :buy_amount, numericality: { greater_than: 0 }
end
