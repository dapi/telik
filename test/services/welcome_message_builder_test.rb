# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

class WelcomeMessageBuilderTest < ActiveSupport::TestCase
  test 'template by default' do
    visit = visits :yandex
    assert_equal WelcomeMessageBuilder.new(visit).build, "yandex: Привет, #{visit.visitor.first_name}! Чем вам помочь?"
  end

  test 'custom template' do
    visit = visits :yandex
    visit.project.welcome_message = 'Привет!'
    assert_equal WelcomeMessageBuilder.new(visit).build, 'Привет!'
  end
end
