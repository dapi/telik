# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Оформляет в модели атрибуты как монетезированные
#
module Monetizer
  def monetize(attr, value:, currency:)
    define_method attr do
      send(currency).to_money(send(value)).freeze
    end
    define_method attr.to_s + '=' do |new_value|
      send currency.to_s + '=', Currency.find(new_value.iso_code) if send(currency).nil?
      raise 'Wrong currency' unless new_value.currency.iso_code == send(currency).iso_code

      send value.to_s + '=', new_value.to_f
    end
  end
end
