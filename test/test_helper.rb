# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/mock'

ApplicationConfig.bot_username = 'TestBot'
ApplicationConfig.bot_token = '123:abc'

require 'telegram_controller_test_case'
require 'telegram_updates'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  teardown do
    Telegram.bot.reset
    # or for multiple bots:
    # Telegram.bots.each_value(&:reset)
  end

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  setup do
    https!
  end

  private

  def false_checkboxes
    html_document.css('span[data-checkbox-value="false"]').map { |e| e.parent.parent.text }
  end

  def true_checkboxes
    html_document.css('span[data-checkbox-value="true"]').map { |e| e.parent.parent.text }
  end

  def checkboxes
    html_document.css('span[data-checkbox]')
  end

  def go_next
    method = html_document.css('a[data-next-button]').attr('data-turbo-method').to_s.presence || :get
    href = html_document.css('a[data-next-button]').attr('href').to_s
    puts [method.upcase, href].join(' ') if ENV['DEBUG_GO_NEXT']
    send method, href
  end

  def login!(params)
    params = params.attributes.slice('id', 'username', 'first_name', 'last_name', 'photo_url').symbolize_keys if params.is_a? ApplicationRecord
    params.reverse_merge! auth_date: Time.zone.now.to_i
    get telegram_auth_callback_path, params: params.merge(hash: TelegramAuthCallbackController.sign_params(params))
    follow_redirect!
  end
end
