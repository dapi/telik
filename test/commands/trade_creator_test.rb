# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class TradeCreatorTest < ActiveSupport::TestCase
  test 'rub' do
    taker = users(:bob)
    advert = adverts(:btc_rub_buy_fixed)
    offer = Offer.
      build_from_advert(advert)
    amount = 1.2
    creator = TradeCreator.
      new(taker: taker, offer: offer, amount: amount)

    assert_instance_of Trade, creator.perform
  end
end
