# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Собственно объявление на обмен
#
class Advert < ApplicationRecord
  extend Monetizer
  # TODO: Сохранять в историю только изменений определенных полей: disabled_at, disable_reason
  # include History
  include Archivation
  include AdvertDisable

  attr_readonly :trader_id, :good_method_currency_id, :advert_type

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

  validates :rate_source, :rate_percent, presence: true, if: :fluid?
  validates :rate_percent, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 100 }, if: :fluid?
  validates :custom_rate_price, numericality: { greater_than: 0 }, presence: true, if: :fixed?

  monetize :min, value: :min_amount, currency: :good_currency
  monetize :max, value: :max_amount, currency: :good_currency

  def active?
    alive? && enabled?
  end

  def rate_price
    @rate_price ||= if fixed?
                      custom_rate_price
                    else
                      RatePriceCalculator
                        .new(advert_type:, rate_percent:, rate_source:)
                        .rate_price ||
                        raise('Must be')
                    end
  end
end
