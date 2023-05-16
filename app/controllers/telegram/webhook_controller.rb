# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Контроллер бота.
#
class Telegram::WebhookController < Telegram::Bot::UpdatesController
  use_session!

  def start!(visit_key = nil, *_args)
    if visit_key.blank?
      respond_with :message, text: 'Привет! Ты кто?'
    elsif visit_key.start_with? Visit::TELEGRAM_KEY_PREFIX
      visit = Visit.includes(:visitor).find_by_telegram_key visit_key
      if visit.nil?
        respond_with :message, text: 'Привет! Визит не найден'
      else
        session[:project_id] = visit.project.id
        RegisterVisitJob.perform_later(visit:, chat:)
        respond_with :message, text: visit.visitor.project.username + ': Привет! Чем вам помочь?'
      end
    else
      respond_with :message, text: 'Привет! Хм..'
    end
  end

  # Пример сообщение которое бот получает сам от себя когда перекидывает его от пользователя в топик
  #
  # {"message_id"=>40,
  # "from"=>{"id"=>943084337, "is_bot"=>false, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "language_code"=>"en"},
  # "chat"=>{"id"=>-1001854699958, "title"=>"Группа поддержки telikbot.ru", "is_forum"=>true, "type"=>"supergroup"},
  # "date"=>1683820391,
  # "message_thread_id"=>30,
  # "reply_to_message"=>
  # {"message_id"=>30,
  # "from"=>{"id"=>5950953118, "is_bot"=>true, "first_name"=>"telik_dev_operator_bot", "username"=>"telik_dev_operator_bot"},
  # "chat"=>{"id"=>-1001854699958, "title"=>"Группа поддержки telikbot.ru", "is_forum"=>true, "type"=>"supergroup"},
  # "date"=>1683819664,
  # "message_thread_id"=>30,
  # "forum_topic_created"=>{"name"=>"@pismenny по имени Danil из (/)", "icon_color"=>7322096},
  # "is_topic_message"=>true},
  # "text"=>"12321",
  # "is_topic_message"=>true}

  # Пример ответа оператора по-делу
  # {
  # "message_id":45,
  # "from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},
  # "chat":{"id":-1001854699958,"title":"Группа поддержки telikbot.ru","is_forum":true,"type":"supergroup"},
  # "date":1683820590,
  # "message_thread_id":30,
  # "reply_to_message":{
  # "message_id":30,
  # "from":{"id":5950953118,"is_bot":true,"first_name":"telik_dev_operator_bot","username":"telik_dev_operator_bot"},
  # "chat":{"id":-1001854699958,"title":"Группа поддержки telikbot.ru","is_forum":true,"type":"supergroup"},
  # "date":1683819664,
  # "message_thread_id":30,
  # "forum_topic_created":{"name":"@pismenny по имени Danil из (/)","icon_color":7322096},
  # "is_topic_message":true
  # },
  # "text":"А оператор отвечает",
  # "is_topic_message":true
  # }

  # Так выглядит сообщение когда пишут напрямую операторскому боту:
  # {
  # "message_id":4,
  # "from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},
  # "chat":{"id":943084337,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","type":"private"},
  # "date":1683820886,
  # "text":"О, работает вроде"
  # }
  #
  # Сообщение оператора в главном топику группы
  # {"message_id":58,
  # "from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},
  # "chat":{"id":-1001854699958,"title":"Группа поддержки nuichat.ru","is_forum":true,"type":"supergroup"},
  # "date":1683824124,
  # "text":"ку"}
  #
  # Еще бывают такие сообщения:
  # {
  # "message_id":65,
  # "from":{"id":6256530950,"is_bot":true,"first_name":"NuiOperatorBot","username":"NuiOperatorBot"},
  # "chat":{"id":-1001854699958,"title":"Группа поддержки nuichat.ru","is_forum":true,"type":"supergroup"},
  # "date":1683826024,
  # "message_thread_id":65,
  # "forum_topic_created":{"name":"#19 @pismenny по имени Danil из Domodedovo (Moscow Oblast/RU)","icon_color":7322096},
  # "is_topic_message":true
  # }
  # Выкинули из чата (помимо my_chat_member приходит еще и такое сообщение, его просто игнорируем)
  # {"message_id":121,
  # "from":{
  # "id":943084337,
  # "is_bot":false,
  # "first_name":"Danil",
  # "last_name":"Pismenny",
  # "username":"pismenny",
  # "language_code":"en"
  # },
  # "chat":{
  # "id":-1001854699958,
  # "title":"Группа поддержки nuichat.ru",
  # "is_forum":true,
  # "type":"supergroup"
  # },
  # "date":1683958326,
  # "left_chat_participant":{
  # "id":6189190373,
  # "is_bot":true,
  # "first_name":"Telik Chat Bot",
  # "username":"telik_chat_bot"
  # },"left_chat_member":{
  # "id":6189190373,
  # "is_bot":true,
  # "first_name":"Telik Chat Bot",
  # "username":"telik_chat_bot"
  # }}

  # Также приходит когда добавляют участника
  # {"message_id"=>7,
  # "from"=>{"id"=>943084337, "is_bot"=>false, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "language_code"=>"en"},
  # "chat"=>{"id"=>-894978656, "title"=>"Группа nuichat.localhost", "type"=>"group", "all_members_are_administrators"=>true},
  # "date"=>1683966286,
  # "new_chat_participant"=>{"id"=>5950953118, "is_bot"=>true, "first_name"=>"telik_dev_operator_bot", "username"=>"telik_dev_operator_bot"},
  # "new_chat_member"=>{"id"=>5950953118, "is_bot"=>true, "first_name"=>"telik_dev_operator_bot", "username"=>"telik_dev_operator_bot"},
  # "new_chat_members"=>[{"id"=>5950953118, "is_bot"=>true, "first_name"=>"telik_dev_operator_bot", "username"=>"telik_dev_operator_bot"}]}

  # Сообщение от клиента
  # {"message_id"=>17,
  # "from"=>{"id"=>943084337, "is_bot"=>false, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "language_code"=>"en"},
  # "chat"=>{"id"=>943084337, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "type"=>"private"},
  # "date"=>1683820060,
  # "text"=>"adas"}
  def message(data)
    Rails.logger.debug data.to_json

    if direct_client_message?
      client_message data
    else
      operator_message data
    end
  end

  def client_message(data)
    # TODO: Если это ответ, то посылать в конкретный проект
    if session[:project_id] && (project = Project.find_by(id: session[:project_id]))
      visitor = project.visitors.find_by(telegram_id: from.fetch('id'))
    end
    visitor ||= Visitor.order(:last_visit_at).where(telegram_id: from.fetch('id')).last
    if visitor.present?
      RedirectClientMessageJob.perform_later visitor, data.fetch('text')
    else
      respond_with :message, text: 'Ой, а мы с вами не знакомы :*'
    end
  end

  def operator_message(data)
    if data['forum_topic_created']
      # Так это мы его сами и создали
    elsif data['is_topic_message']
      # TODO: Найти проект по chat.id
      visitor = Visitor.find_by(telegram_message_thread_id: data.fetch('message_thread_id'))
      if visitor.present?
        ClientMessageJob.perform_later visitor, data.fetch('text')
      else
        reply_with :message, text: 'Не нашел посетителя прикрепленного к этому треду :*'
      end
    elsif chat['is_forum']
      # Возможно надо проверять еще на chat['supergroup']
      # Похоже пишут в главном топике группы
    elsif chat['type'] == 'group'
      # Возможно сообщение о добавлении пользователей
    else
      respond_with :message, text: 'Пока со мной напрямую разговаривать нет смысла, пишите в группе'
    end
  end

  # Добавили в чат
  # {"chat":{"id":-1001854699958,"title":"Группа поддержки nuichat.ru","is_forum":true,"type":"supergroup"},"from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},"date":1683823941,"old_chat_member":{"user":{"id":6256530950,"is_bot":true,"first_name":"NuiOperatorBot","username":"NuiOperatorBot"},"status":"administrator","can_be_edited":false,"can_manage_chat":true,"can_change_info":true,"can_delete_messages":true,"can_invite_users":true,"can_restrict_members":true,"can_pin_messages":true,"can_manage_topics":false,"can_promote_members":false,"can_manage_video_chats":true,"is_anonymous":false,"can_manage_voice_chats":true},"new_chat_member":{"user":{"id":6256530950,"is_bot":true,"first_name":"NuiOperatorBot","username":"NuiOperatorBot"},"status":"administrator","can_be_edited":false,"can_manage_chat":true,"can_change_info":true,"can_delete_messages":true,"can_invite_users":true,"can_restrict_members":true,"can_pin_messages":true,"can_manage_topics":true,"can_promote_members":false,"can_manage_video_chats":true,"is_anonymous":false,"can_manage_voice_chats":true}
  #

  # Добавили админом
  # {
  # "update_id":841395543,
  # "my_chat_member":{
  # "chat":{"id":-1001854699958,"title":"Группа поддержки nuichat.ru","is_forum":true,"type":"supergroup"},
  # "from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},
  # "date":1683831867,
  # "old_chat_member":{
  # "user":{"id":5950953118,"is_bot":true,"first_name":"telik_dev_operator_bot","username":"telik_dev_operator_bot"},
  # "status":"member"
  # },
  # "new_chat_member":{
  # "user":{"id":5950953118,"is_bot":true,"first_name":"telik_dev_operator_bot","username":"telik_dev_operator_bot"},
  # "status":"administrator",
  # "can_be_edited":false,
  # "can_manage_chat":true,
  # "can_change_info":true,
  # "can_delete_messages":true,
  # "can_invite_users":true,
  # "can_restrict_members":true,
  # "can_pin_messages":true,
  # "can_manage_topics":false,
  # "can_promote_members":false,
  # "can_manage_video_chats":true,
  # "is_anonymous":true,
  # "can_manage_voice_chats":true
  # }
  # }
  # }

  # Сменили статус
  # {"chat":{
  # "id":-1001854699958,
  # "title":"Группа поддержки nuichat.ru",
  # "is_forum":true,
  # "type":"supergroup"
  # },"from":{
  # "id":943084337,
  # "is_bot":false,
  # "first_name":"Danil",
  # "last_name":"Pismenny",
  # "username":"pismenny",
  # "language_code":"en"
  # },
  # "date":1683831677,
  # "old_chat_member":{
  # "user":{
  # "id":5950953118,
  # "is_bot":true,
  # "first_name":"telik_dev_operator_bot",
  # "username":"telik_dev_operator_bot"
  # },
  # "status":"administrator",
  # "can_be_edited":false,
  # "can_manage_chat":true,
  # "can_change_info":true,
  # "can_delete_messages":true,
  # "can_invite_users":true,
  # "can_restrict_members":true,
  # "can_pin_messages":true,
  # "can_manage_topics":true,
  # "can_promote_members":false,
  # "can_manage_video_chats":true,
  # "is_anonymous":false,
  # "can_manage_voice_chats":true
  # },
  # "new_chat_member":{
  # "user":{
  # "id":5950953118,
  # "is_bot":true,
  # "first_name":"telik_dev_operator_bot",
  # "username":"telik_dev_operator_bot"
  # },
  # "status":"member"
  # }}
  #
  # Изменили доступы:
  # {"chat"=>{"id"=>-1001854699958, "title"=>"Группа поддержки nuichat.ru", "is_forum"=>true, "type"=>"supergroup"},
  # "from"=>{"id"=>943084337, "is_bot"=>false, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "language_code"=>"en"},
  # "date"=>1683964878,
  # "old_chat_member"=>
  # {"user"=>{"id"=>5950953118, "is_bot"=>true, "first_name"=>"telik_dev_operator_bot", "username"=>"telik_dev_operator_bot"},
  # "status"=>"administrator",
  # "can_be_edited"=>false,
  # "can_manage_chat"=>true,
  # "can_change_info"=>true,
  # "can_delete_messages"=>true,
  # "can_invite_users"=>true,
  # "can_restrict_members"=>true,
  # "can_pin_messages"=>true,
  # "can_manage_topics"=>true,
  # "can_promote_members"=>false,
  # "can_manage_video_chats"=>true,
  # "is_anonymous"=>true,
  # "can_manage_voice_chats"=>true},
  # "new_chat_member"=>
  # {"user"=>{"id"=>5950953118, "is_bot"=>true, "first_name"=>"telik_dev_operator_bot", "username"=>"telik_dev_operator_bot"},
  # "status"=>"restricted",
  # "until_date"=>0,
  # "can_send_messages"=>true,
  # "can_send_media_messages"=>true,
  # "can_send_audios"=>true,
  # "can_send_documents"=>true,
  # "can_send_photos"=>true,
  # "can_send_videos"=>true,
  # "can_send_video_notes"=>true,
  # "can_send_voice_notes"=>true,
  # "can_send_polls"=>true,
  # "can_send_other_messages"=>true,
  # "can_add_web_page_previews"=>true,
  # "can_change_info"=>true,
  # "can_invite_users"=>true,
  # "can_pin_messages"=>true,
  # "can_manage_topics"=>false,
  # "is_member"=>true}}

  # Турнули
  #
  # {"chat"=>{"id"=>-1001854699958, "title"=>"Группа поддержки nuichat.ru", "is_forum"=>true, "type"=>"supergroup"},
  # "from"=>{"id"=>943084337, "is_bot"=>false, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "language_code"=>"en"},
  # "date"=>1683965960,
  # "old_chat_member"=>
  # {"user"=>{"id"=>5950953118, "is_bot"=>true, "first_name"=>"telik_dev_operator_bot", "username"=>"telik_dev_operator_bot"},
  # "status"=>"restricted",
  # "until_date"=>0,
  # "can_send_messages"=>true,
  # "can_send_media_messages"=>true,
  # "can_send_audios"=>true,
  # "can_send_documents"=>true,
  # "can_send_photos"=>true,
  # "can_send_videos"=>true,
  # "can_send_video_notes"=>true,
  # "can_send_voice_notes"=>true,
  # "can_send_polls"=>true,
  # "can_send_other_messages"=>true,
  # "can_add_web_page_previews"=>true,
  # "can_change_info"=>true,
  # "can_invite_users"=>true,
  # "can_pin_messages"=>false,
  # "can_manage_topics"=>false,
  # "is_member"=>true},
  # "new_chat_member"=>
  # {"user"=>{"id"=>5950953118, "is_bot"=>true, "first_name"=>"telik_dev_operator_bot", "username"=>"telik_dev_operator_bot"}, "status"=>"left"}}

  # Добавили в обычную группу
  # {"chat"=>{"id"=>-894978656, "title"=>"Группа nuichat.localhost", "type"=>"group", "all_members_are_administrators"=>false},
  # "from"=>{"id"=>943084337, "is_bot"=>false, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "language_code"=>"en"},
  # "date"=>1683966286,
  # "old_chat_member"=>
  # {"user"=>{"id"=>5950953118, "is_bot"=>true, "first_name"=>"telik_dev_operator_bot", "username"=>"telik_dev_operator_bot"}, "status"=>"left"},
  # "new_chat_member"=>
  # {"user"=>{"id"=>5950953118, "is_bot"=>true, "first_name"=>"telik_dev_operator_bot", "username"=>"telik_dev_operator_bot"}, "status"=>"member"}}
  def my_chat_member(data)
    # Кого-то другого добавили, не нас
    return unless data.dig('new_chat_member', 'user', 'username') == Telegram.bot.username

    chat_member = data.fetch('new_chat_member')
    user = User
           .create_with(telegram_data: from)
           .create_or_find_by!(telegram_id: from.fetch('id'))

    project = Project
              .create_with(owner: user, chat_member_updated_at: Time.zone.now, chat_member:, name: chat.fetch('title'))
              .create_or_find_by!(telegram_group_id: chat.fetch('id'))

    update_project_bot_member!(project:, chat_member:, user:)
  end

  private

  def direct_client_message?
    from['id'] == chat['id'] && !from['is_bot'] && chat['type'] == 'private'
  end

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
