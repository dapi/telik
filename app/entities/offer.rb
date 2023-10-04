# Вычисленное предложение по конкретному объявлению
class Offer
  COMISSION_PERCENT = 1.0 # Сейчас комиссия всегда 1%

  include ActiveModel::Model

  attr_reader :advert, :at, :updated_at, :rate_price, :comission_percent

  def self.build_from_advert(advert)
    new(advert: advert, updated_at: advert.updated_at, rate_price: advert.rate_price, comission_percent: COMISSION_PERCENT, at: Time.zone.now)
  end

  def transfer_currency
    advert.payment_currency
  end

  def transfers_for(amount)
    total_transfer_amount = transfer_currency.operational_round amount * rate_price
    comission_amount = total_transfer_amount * Percent.new(comission_percent)

    {
      transfer_currency: transfer_currency,
      # Сколько всего переводится оплаты
      total_transfer_amount: total_transfer_amount,
      # Сколько из них комиссия
      comission_amount: comission_amount,
      # Сколько из них клиенту
      client_transfer_amount: total_transfer_amount - comission_amount,
      comission_percent: comission_percent
    }
  end
end
