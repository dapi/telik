# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

# Уже зарегистрированный пользователь выбирает бесплатный тариф и создаёт проект
#
class NewPaidProjectFlowTest < ActionDispatch::IntegrationTest
  fixtures :tariffs, :telegram_users

  test 'Зарегистрированный пользователь выбирает платный тариф и создаёт проект' do
    login! telegram_users(:new_user)
    get new_project_path(project: { tariff_id: tariffs(:paid).id })
    assert_select 'h1', 'Создайте бота в Telegram'

    bot = Minitest::Mock.new
    bot_name = 'MyCutstomBot'
    bot.expect :get_me, { 'result' => { 'username' => bot_name } }
    bot.expect :get_chat, { 'ok' => true, 'result' => { 'title' => 'group name', 'type' => 'supergroup', 'permissions' => { 'can_manage_topics' => true } } }, chat_id: 10_001

    Telegram::Bot::Client.stub :new, bot do
      post projects_path, params: { project: { tariff_id: tariffs(:paid).id, bot_token: '123:abc' } }
    end
    follow_redirect!

    assert_select 'h1', I18n.t(:support_group)
    assert_select 'a[data-next-button]', 'Проверить →'

    # Видим инструкцию на 5 пунктов
    #
    assert_equal 5, false_checkboxes.count, true_checkboxes.join(', ')
    #
    # # но ничего не делаем и просто идем дальше
    go_next
    follow_redirect!

    # И получаем тоже самое
    assert_select 'h1', I18n.t(:support_group)

    assert_equal 1, telegram_users(:new_user).user.projects.count
    project = telegram_users(:new_user).user.projects.take
    # Сделали почти все что надо в телеге
    project.update!(
      telegram_group_id: 10_001,
      chat_member_updated_at: Time.zone.now,
      chat_member: {},
      telegram_group_name: 'test',
      telegram_group_type: 'supergroup',
      telegram_group_is_forum: true,
      bot_status: 'administrator',
      bot_can_manage_topics: true
    )

    Telegram::Bot::Client.stub :new, bot do
      go_next
    end
    follow_redirect!
    follow_redirect!

    assert_includes html_document.to_s, 'Поздравляю! Бот подключен'
    assert_select 'h1', "Установка виджета на сайт #{project.name}"

    # Устанавливаем виджет на сайт
    # и где-то в другой вкладке идем по кнопке
    open_session do |sess|
      sess.get v_path(pk: project.key)
      sess.assert_redirected_to %r{https://t\.me}
    end

    go_next
    follow_redirect!

    assert_includes html_document.to_s, 'Виджет отлично установлен на сайт'
  end
end
