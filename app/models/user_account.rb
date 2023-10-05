# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Связка между пользователем и аккаунтом в openbill для конкретной валюты
class UserAccount < ApplicationRecord
  belongs_to :user
  belongs_to :openbill_account
  belongs_to :currency

  before_create do
    raise unless currency == openbill_account.currency
  end
end
