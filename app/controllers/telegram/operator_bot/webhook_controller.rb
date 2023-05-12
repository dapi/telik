# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Контроллер операторского бота.
#
class Telegram::OperatorBot::WebhookController < Telegram::Bot::UpdatesController
  def start!(*_args)
    respond_with :message, text: 'Привет, оператор!'
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
  def message(data)
    Rails.logger.debug data.to_json
    if data['forum_topic_created']
      # Так это мы его сами и создали
    elsif data['is_topic_message']
      # TODO: Найти проект по chat.id
      visitor = Visitor.find_by(telegram_message_thread_id: data.fetch('message_thread_id'))
      if visitor.present?
        ClientMessageJob.perform_later visitor, data.fetch('text')
      else
        respond_with :message, text: 'Не нашел посетителя прикрепленного к этому треду :*'
      end
    elsif chat['is_forum']
      # Похоже пишут в главном топике группы
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

  # Турнули из чата
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

  def my_chat_member(data)
    # Кого-то другого добавили, не нас
    return unless data.dig('new_chat_member', 'user', 'username') == Telegram.bots[:operator].username

    chat_member = data.fetch('new_chat_member')

    # Кто добавил
    user = User.find_by(telegram_id: from.fetch('id'))

    if user.present?
      project = Project
                .create_with(owner: user, chat_member_updated_at: Time.zone.now, chat_member:, name: chat.fetch('title'))
                .create_or_find_by!(telegram_group_id: chat.fetch('id'))

      project.assign_attributes(chat_member_updated_at: Time.zone.now, chat_member:)
      project.save! if project.changed?

      if chat_member.fetch('status') == 'administrator'
        if chat_member.fetch('can_manage_topics')
          # TODO: Уведомить оператора через action cable
          # TODO Показать код виджета
        else
          respond_with :message, text: 'Добавьте мне прав управления топиками'
        end
      else
        respond_with :message, text: 'Сделайте меня администратором и дайте права управления топиками'
      end
    else
      Rails.logger.warn('Unknown owner')
      # TODO: А что делать если надо добавил не известно кто? Написать ему в личку?
    end
  end
end
