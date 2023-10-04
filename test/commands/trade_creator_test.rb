# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class TradeCreatorTest < ActiveSupport::TestCase
  test 'rub' do
    taker = users(:bob)
    advert = adverts(:btc_rub_buy_fixed)
    offer = Offer
      .build_from_advert(advert)
    amount = advert.good_currency.to_money 1.2
    creator = TradeCreator
      .new(taker:, offer:, amount:)

    assert_instance_of Trade, creator.perform
  end
end
