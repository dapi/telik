# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class AdvertTest < ActiveSupport::TestCase
  fixtures :users, :payment_methods, :payment_method_currencies, :adverts
  test 'the truth' do
    advert = adverts(:btc_rub_buy_fluid)
    assert_instance_of Money, advert.min
  end
end
