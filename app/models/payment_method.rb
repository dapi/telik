# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Платежный метод
#
class PaymentMethod < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
