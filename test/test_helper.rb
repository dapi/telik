# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/mock'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  teardown do
    Telegram.bot.reset
    # or for multiple bots:
    Telegram.bots.each_value(&:reset)
  end

  # Add more helper methods to be used by all tests here...
end
