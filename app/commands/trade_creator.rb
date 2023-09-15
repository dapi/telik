
# Создает сделку по объявлению
#
class TradeCreator
  Error = Class.new StandardError

  def initialize(taker: , advert: )
    @taker = taker || raise 'Taker must be'
    @advert = advert || raise 'Advert must be'
  end

  def perform
    @advert.with_lock do
      raise Error, 'Advert must be active' unless @advert.active?

      Trade.create!(
        advert: @advert,
        taker: @taker,
        advert_details: @advert.details
        advert_dump: @advert.as_json,

        rate_type: @advert.rate_type,
        rate_percent: @advert.rate_percent,

      )
    end
    sell_amount: 1
    sell_currency_id: btc
    buy_amount: 100_000
    buy_currency_id: rub
    comission_currency_id: btc
    comission_amount: 0.0001
    rate_type: fixed
    rate_price: 100_000
    )
  end
end
