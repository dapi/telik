# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Транзакция
class OpenbillTransaction < OpenbillRecord
  belongs_to :from_account, class_name: 'OpenbillAccount'
  belongs_to :to_account, class_name: 'OpenbillAccount'

  scope :ordered, -> { order 'date desc' }
  scope :by_any_account_id, ->(id) { where('from_account_id = ? or to_account_id = ?', id, id) }
  scope :by_period, lambda { |period|
    scope = all
    scope = scope.where('date >= ?', period.first) if period.first.present?
    scope = scope.where('date <= ?', period.last) if period.last.present?
    scope
  }

  scope :by_month, ->(month) { by_period Range.new(month.beginning_of_month, month.end_of_month) }

  monetize :amount_cents, as: :amount, with_model_currency: :amount_currency

  def billing_url
    "#{Settings.billing_host}/transactions/#{id}"
  end
end
