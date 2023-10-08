# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

# Регистрируется новый пользователь, проходит через тариф и доходит до интегрированного бота и рабочего стола
#
class NewUserFlowTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    https!
  end

  test 'Новый пользователь проходит путь с главной страницы до создания бесплатного проекта' do
    get '/'
    assert_response :success

    assert_select "a[href='#{new_project_path}']"

    # Пошли на странице нового проекта
    get new_project_path

    # И тут видим что нам надо авторизоваться
    assert_select 'div', 'Для дальнейших действий необходимо представиться'

    # И еще телеграмовскую кнопку для логина
    assert_select 'script[data-telegram-login]'

    # Типа на неё жмякаем и нас кидает обратно уже с авторизационными данными
    data = { id: 10_000, username: 'newuser', first_name: 'new', last_name: 'other', photo_url: 'https://', auth_date: Time.zone.now.to_i }
    get telegram_auth_callback_path, params: data.merge(hash: TelegramAuthCallbackController.sign_params(data))
    follow_redirect!

    assert_select 'h1', 'Выберите тариф'
  end
end
