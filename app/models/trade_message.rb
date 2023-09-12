# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

class TradeMessage < ApplicationRecord
  belongs_to :trade
  belongs_to :user
end
