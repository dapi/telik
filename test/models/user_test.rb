# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  test 'user is persisted' do
    assert users(:one).persisted?
  end
end
