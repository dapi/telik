# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class VisitorSessionTest < ActiveSupport::TestCase
  test 'session is persisted' do
    assert visitor_sessions(:yandex).persisted?
  end
end
