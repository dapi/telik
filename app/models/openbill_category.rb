# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Категория аккаунта в openbill
#
class OpenbillCategory < OpenbillRecord
  has_many :accounts, class_name: 'OpenbillAccount', foreign_key: :category_id, inverse_of: :category, dependent: :restrict
  has_many :income_transactions, through: :accounts
  has_many :outcome_transactions, through: :accounts

  def self.user
    find_or_create_by!(name: 'users_balances')
  end
end
