# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Собственно объявление на обмен
#
class Advert < ApplicationRecord
  # TODO: Сохранять в историю только изменений определенных полей: disabled_at, disable_reason
  include History
  include Archivation
  include AdvertDisable

  belongs_to :trader, class_name: 'User'
  # Что покупаем/продаем (чем торгуем)
  belongs_to :good_method_currency, class_name: 'PaymentMethodCurrency'

  # За что покупаем/продаем (валюта оплаты)
  belongs_to :payment_method_currency, class_name: 'PaymentMethodCurrency'

  belongs_to :rate_source, optional: true

  has_one :good_currency, through: :good_method_currency, source: :currency
  has_one :payment_currency, through: :payment_method_currency, source: :currency

  has_many :trades, dependent: :restrict_with_exception

  scope :active, -> { alive.enabled }

  # Предлагаем купить или продать?
  #
  enum :advert_type, %w[buy sell].each_with_object({}) { |k, a| a[k] = k }

  # Тип курса
  enum :rate_type, %w[fixed fluid].each_with_object({}) { |k, a| a[k] = k }

  def active?
    alive? && enabled?
  end
end
