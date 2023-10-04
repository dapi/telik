# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Калькулятор высчитывает курс объявления на основе плавающего курса
#
class RatePriceCalculator
  def initialize(advert_type:, rate_percent:, rate_source:)
    @advert_type = advert_type
    @rate_source = rate_source
    @rate_percent = rate_percent
  end

  def rate_price
    raise 'not implemented'
  end
end
