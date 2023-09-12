# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

class OpenbillAccount < OpenbillRecord
  belongs_to :category, class_name: 'OpenbillCategory'
  belongs_to :reference, polymorphic: true

  has_many :income_transactions, class_name: 'OpenbillTransaction', foreign_key: :to_account_id
  has_many :outcome_transactions, class_name: 'OpenbillTransaction', foreign_key: :from_account_id

  scope :ordered, -> { order :id }

  monetize :amount_value, as: :amount, with_model_currency: :amount_currency

  def to_s
    "#{details} [#{key}]"
  end

  def billing_url
    "#{Settings.billing_host}/accounts/#{id}"
  end

  def new_outcome_transaction_billing_url(opposite_account_id:)
    billing_url + "/transactions/new?direction=outcome&account_transaction_form[opposite_account_id]=#{opposite_account_id}"
  end

  def new_income_transaction_billing_url(opposite_account_id:)
    billing_url + "/transactions/new?direction=income&account_transaction_form[opposite_account_id]=#{opposite_account_id}"
  end

  def amount_by_period(period)
    sql = ApplicationRecord.send(:sanitize_sql_array, ['SELECT openbill_period_amount(?, ?, ?) FROM openbill_accounts WHERE id = ?', id, period.first, period.last, id])
    value = OpenbillAccount.connection.select_value sql
    return unless value

    Money.new value, amount_currency
  end

  def all_transactions
    OpenbillTransaction.by_any_account_id id
  end

  def name
    key.presence || id.to_s
  end

  def url
    meta['url']
  end
end
