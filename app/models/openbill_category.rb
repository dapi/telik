# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

class OpenbillCategory < OpenbillRecord
  has_many :accounts, class_name: 'OpenbillAccount', foreign_key: :category_id

  has_many :income_transactions, through: :accounts
  has_many :outcome_transactions, through: :accounts

  def self.user
    find_or_create_by!(name: 'users_balances')
  end
end
