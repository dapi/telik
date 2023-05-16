# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Метод обновляет статусы членства проекта в его группе
#
module Telegram::UpdateProjectMembership
  private

  def update_project_bot_member!(project:, chat_member:, user:)
    project.update_bot_member!(chat_member:, chat:)

    # TODO: Сообщить пользователю ссылку на сайт для авторизации если он ни свеже созданный и еще ниразу не авторизовывался
    # unless user.last_login_at?

    text = []
    unless user.last_login_at?
      text += [
        "Привет, #{user.first_name}!",
        'Мы с тобой ещё не знакомы.',
        "Зайди на #{Rails.application.routes.url_helpers.project_url(project)} чтобы получить код виджета и инструкции по настройке.",
        ''
      ]
    end
    if chat.fetch('type') == 'supergroup'
      text << 'В этой супер-группе необходимо разрешить топики' unless chat['is_forum']
    else
      text << 'В группе необходимо разрешить топики (сделать её супер-группой)'
    end

    if chat_member.fetch('status') == 'administrator'
      if chat_member.fetch('can_manage_topics')
        # TODO: Уведомить оператора через action cable
        # TODO Показать код виджета
        text += [
          'Поздравляю! Я успешно подключен!',
          "Зайди на #{Rails.application.routes.url_helpers.project_url(project)} чтобы получить код виджета и инструкции по настройке."
        ]
      else
        text << 'Добавьте мне прав управления топиками'
      end
    else
      text << 'Сделайте меня администратором и дайте права управления топиками'
    end
    respond_with :message, text: text.flatten.join("\n")
  end
end
