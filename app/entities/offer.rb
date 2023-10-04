# Вычисленное предложение по конкретному объявлению
class Offer
  COMISSION_PERCENT = 1.0 # Сейчас комиссия всегда 1%

  include ActiveModel::Model

  attr_reader :advert, :advert_id, :at, :rate_price, :comission_percent

  def self.build_from_advert(advert)
    new(advert: advert, rate_price: advert.rate_price)
  end

  def advert=(new_advert)
    @advert = new_advert
    @advert_id = new_advert.id
    @at = new_advert.updated_at
  end
end
