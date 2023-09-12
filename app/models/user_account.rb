# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

class UserAccount < ApplicationRecord
  belongs_to :user
  belongs_to :openbill_account

  before_create do
    currency_code == openbill_account.currency_code
  end
end
