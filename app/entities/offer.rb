# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Вычисленное предложение по конкретному объявлению
class Offer
  COMISSION_PERCENT = 1.0 # Сейчас комиссия всегда 1%

  include ActiveModel::Model

  attr_accessor :advert, :at, :updated_at, :rate_price, :comission_percent

  def self.build_from_advert(advert)
    new(advert:, updated_at: advert.updated_at, rate_price: advert.rate_price, comission_percent: COMISSION_PERCENT, at: Time.zone.now)
  end

  def transfer_currency
    advert.payment_currency
  end

  def transfers_for(amount)
    total_transfer = transfer_currency.to_money amount.to_f * rate_price
    comission = total_transfer * Percent.new(comission_percent)

    {
      transfer_currency:,
      # Сколько всего переводится оплаты
      total_transfer:,
      # Сколько из них комиссия
      comission:,
      # Сколько из них клиенту
      client_transfer: total_transfer - comission,
      comission_percent:
    }
  end
end
