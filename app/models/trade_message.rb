# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Сообщение в сделке
class TradeMessage < ApplicationRecord
  belongs_to :trade
  belongs_to :user

  validates :content, presence: true
end
