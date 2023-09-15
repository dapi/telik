
# Создает сделку по объявлению
#
class TradeCreator
  Error = Class.new StandardError

  # taker - кто откликается на предложение
  # offer - собственно предложение
  # good_amount - сколько покупает/продает
  def initialize(taker: , offer: , good_amount:)
    @taker = taker || raise 'Taker must be'
    @offer = offer || raise 'Offer must be'
    @good_amount = good_amount || raise 'Must be'
  end

  def perform
    offer.advert.with_lock do
      raise Error, 'Advert must be active' unless offer.advert.active?

      Trade.create!(
        advert: @advert,
        taker: @taker,
        advert_details: @advert.details
        advert_dump: @advert.as_json,

        rate_type: @advert.rate_type,
        rate_percent: @advert.rate_percent,
      )
    end
    good_amount: 1
    good_currency_id: btc
    payment_amount: 100_000
    payment_currency_id: rub
    comission_currency_id: btc
    comission_amount: 0.0001
    rate_type: fixed
    rate_price: 100_000
    )
  end

  private

  attr_reader :offer, :taker
end
