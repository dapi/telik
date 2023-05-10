# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

class VisitorTest < ActiveSupport::TestCase
  fixtures :visitors

  test 'visitor is persisted' do
    assert visitors(:yandex).persisted?
  end
end
