# Вычисленное предложение по конкретному объявлению
class Offer
  include ActiveModel::Model

  attr_accessor :advert_id, :at, :rate_price

  def initialize(advert: )
    @advert = advert
  end
end
