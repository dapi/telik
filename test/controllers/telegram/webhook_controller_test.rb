# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class TelegramWebhookControllerTest < ActionDispatch::IntegrationTest
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
  #
  #
  # Поймал в operator_message
  #  {"update_id":124132485,"message":{"message_id":47,"from":{"id":5933409757,"is_bot":true,"first_name":"Nui Chat","username":"NuiChatBot"},"chat":{"id":-1001989718457,"title":"kiiiosk.store","is_forum":true,"type":"supergroup"},"date":1684320600,"message_thread_id":29,"forum_topic_edited":{"name":"#53 Danil Pismenny (127.0.0.1)"},"is_topic_message":true}}

  test 'message' do
    assert true
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
  test 'my_chat_member' do
    assert true
  end
end
