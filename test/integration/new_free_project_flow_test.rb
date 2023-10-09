# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

# Уже зарегистрированный пользователь выбирает бесплатный тариф и создаёт проект
#
class NewFreeProjectFlowTest < ActionDispatch::IntegrationTest
  fixtures :tariffs, :telegram_users

  test 'Зарегистрированный пользователь выбирает бесплатный тариф и создаёт проект' do
    login! telegram_users(:new_user)
    get new_project_path(project: { tariff_id: tariffs(:free).id })
    assert_select 'h1', 'Нужна супер-группа в телеграм'

    assert_select 'a[data-next-button]', 'Проверить →'

    # Видим инструкцию на 5 пунктов
    #
    assert_equal 5, false_checkboxes.count, true_checkboxes.join(', ')
    #
    # # но ничего не делаем и просто идем дальше
    go_next

    # И получаем тоже самое
    assert_select 'h1', 'Нужна супер-группа в телеграм'

    # Нотеперь мы делаем все как положенно по-инструкции
    user = users(:new_user)

    # Проект создается через сообщение в телеге
    project = Project
      .create!(
        owner: user,
        telegram_group_id: 10_001,
        chat_member_updated_at: Time.zone.now,
        chat_member: {},
        telegram_group_name: 'test',
        name: 'test',
        tariff: Tariff.free!
      )

    # Идем дальше
    go_next
    follow_redirect!

    assert_equal 1, true_checkboxes.count, false_checkboxes.join('; ')
    assert_includes true_checkboxes.join, 'Создана группа с названием'

    # Сделали почти все что надо в телеге
    project.update!(
      telegram_group_type: 'supergroup',
      telegram_group_is_forum: true,
      bot_status: 'administrator'
    )

    bot = Minitest::Mock.new
    bot_name = 'MyCutstomBot'
    bot.expect :get_me, { 'result' => { 'username' => bot_name } }
    bot.expect :get_chat, { 'result' => {} }
    # Telegram::Bot::Client.stub :new, bot do

    go_next
    follow_redirect!
    assert_equal 4, true_checkboxes.count, false_checkboxes.join('; ')

    # Добавили последнюю фичу
    project.update!(
      bot_can_manage_topics: true
    )

    go_next
    follow_redirect!
    follow_redirect!

    assert_includes html_document.to_s, 'Поздравляю! Бот подключен'
    assert_select 'h1', 'Установка виджета на сайт test'

    # Ничего не сделали и нажали Дальше
    go_next
    follow_redirect!

    assert_includes html_document.to_s, 'Проверка не прошла'
    assert_select 'h1', 'Установка виджета на сайт test'

    # Устанавливаем видет на сайт
    # и где-то в другой вкладке идем по кнопке
    open_session do |sess|
      sess.get v_path(pk: project.key)
      sess.assert_redirected_to %r{https://t\.me}
    end

    go_next
    follow_redirect!
    # end

    assert_includes html_document.to_s, 'Виджет отлично установлен на сайт'
  end
end
