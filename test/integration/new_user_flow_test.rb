# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

# Регистрируется новый пользователь, регистрируется и доходит до выбора тарифа
#
class NewUserFlowTest < ActionDispatch::IntegrationTest
  fixtures :tariffs

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

    assert_difference -> { User.count } do
      # Типа на неё жмякаем и нас кидает обратно уже с авторизационными данными
      login! id: 10_000, username: 'newuser', first_name: 'new', last_name: 'other', photo_url: 'https://'
    end

    assert_select 'h1', 'Выберите тариф'
  end
end
