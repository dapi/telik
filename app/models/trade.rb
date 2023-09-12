# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

class Trade < ApplicationRecord
  belongs_to :advert
  belongs_to :taker, class_name: 'User'
  belongs_to :sell_currency, class_name: 'Currency'
  belongs_to :buy_currency, class_name: 'Currency'

  include TradeStateMachine

  before_save do
    self.history = history_was << { at: Time.zone.now, changes: }
  end
end
