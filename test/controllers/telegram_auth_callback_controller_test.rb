# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

class TelegramAuthCallbackControllerTest < ActionDispatch::IntegrationTest
  # test 'receive callback data, create user and login him' do
  # ApplicationConfig.stub :bot_token, '123' do
  # telegram_user_id = Random.rand(1..100_000)
  # data = { 'auth_date' => Time.zone.now.to_i, 'id' => telegram_user_id, 'first_name' => 'Danil', 'last_name' => 'Pismenny', 'username' => 'pismenny' }
  # params = data.merge(hash: TelegramAuthCallbackController.sign_params(data))
  # get telegram_auth_callback_path(params)
  # assert_response :redirect
  # user = User.find_by(telegram_user_id:)
  # assert user
  # assert_equal telegram_user_id, user.telegram_data.fetch('id').to_i
  # assert_equal user.id, session[:user_id].to_i
  # end
  # end
end
