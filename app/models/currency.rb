# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Модель валюты
#
class Currency < ApplicationRecord
  # NOTE: type column reserved for STI
  self.inheritance_column = nil
  attr_readonly :id, :type

  before_create do
    raise "ID must be upcased (#{id})" unless id == id.upcase
  end

  enum :type, %w[coin fiat].each_with_object({}) { |k, a| a[k] = k }

  # Allows to dynamically check value of id/code:
  #
  #   id.btc? # true if code equals to "btc".
  #   code.eth? # true if code equals to "eth".
  def id
    super&.inquiry
  end

  # Округляем до разумных пределов чтобы не зарываться в копейках
  def operational_round(amount)
    amount
    # TODO: Округлять до нужных цифр
    # Не уверен что тут должен быть именно precision
    # amount.round precision.to_i
  end

  def token_name
    return unless token?

    id.to_s.upcase.split(ID_SEPARATOR).first.presence
  end

  def icon_id
    id.to_s.downcase.split(ID_SEPARATOR).first.presence
  end

  def to_money(decimal)
    Money.new(decimal * base_factor, id)
  end

  def iso_code
    id.to_sym
  end

  # subunit (or fractional monetary unit) - a monetary unit
  # that is valued at a fraction (usually one hundredth)
  # of the basic monetary unit
  def subunits=(num)
    self.base_factor = 10**num
  end

  def subunits
    Math.log(base_factor, 10).round
  end

  # This method defines that token currency need to have parent_id and coin type
  # We use parent_id for token type to inherit some useful info such as blockchain_key from parent currency
  # For coin currency enough to have only coin type
  def token?
    parent_id.present? && coin?
  end

  def subunit_to_unit
    base_factor
  end
end
