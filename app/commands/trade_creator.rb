# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Создает сделку по объявлению
#
class TradeCreator
  COMISSION_PERCENTS = 1.0 # Сейчас комиссия всегда 1%
  Error = Class.new StandardError

  # TODO
  # taker - кто откликается на предложение
  # offer - собственно предложение
  # amount - сколько покупает/продает
  def initialize(taker:, offer:, amount:)
    @taker = taker || raise('Taker must be')
    @offer = offer || raise('Offer must be')
    @amount = amount || raise('Must be')
    raise unless amount.is_a? Money
  end

  def perform
    offer.advert.with_lock do
      advert = offer.advert
      raise Error, 'Advert is updated' unless offer.updated_at == advert.updated_at
      raise Error, 'Advert must be an active' unless advert.active?

      errors = []

      raise unless amount.currency.iso_code == advert.good_currency.iso_code

      errors << :max if amount > advert.max
      errors << :min if amount < advert.min

      # TODO: Проверить баланс трейдера или покупателя и заблокировать средства
      # TODO Проверить rate_price на адекватность advert.rate_price (допустимые изменение в пределах 0.01%)

      raise Error, errors if errors.any?

      attrs = {
        taker:,

        advert:,
        advert_details: advert.details,
        advert_dump: advert.as_json,
        rate_type: advert.rate_type,
        rate_percent: advert.rate_percent,
        good_currency: advert.good_currency,

        rate_price: offer.rate_price,

        good_amount: amount
      }
      transfers = offer.transfers_for(amount)

      Trade.create! attrs.merge transfers
    end
  end

  private

  attr_reader :offer, :taker, :amount
end
