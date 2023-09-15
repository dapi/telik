# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class TradeCreatorTest < ActiveSupport::TestCase
  test 'rub' do
    taker = users(:bob)
    advert = adverts(:btc_rub_buy_fixed)
    creator = TradeCreator.new(taker: taker, advert: advert)

    assert_instance_of Trade, creator.perform
  end
end
