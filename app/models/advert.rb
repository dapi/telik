# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Собственно объявление на обмен
#
class Advert < ApplicationRecord
  belongs_to :maker, class_name: 'User'
  # Что предлагаем
  belongs_to :make_method_currency, class_name: 'PaymentMethodCurrency'

  # Что забираем
  belongs_to :take_method_currency, class_name: 'PaymentMethodCurrency'
  belongs_to :rate_source, optional: true

  has_one :make_currency, through: :make_method_currency, source: :currency
  has_one :take_currency, through: :take_method_currency, source: :currency

  has_many :trades, dependent: :restrict_with_exception

  # Предлагаем купить или продать?
  #
  enum :advert_type, %w[buy sell].each_with_object({}) { |k, a| a[k] = k }

  # Тип курса
  enum :rate_type, %w[fixed fluid].each_with_object({}) { |k, a| a[k] = k }
end
