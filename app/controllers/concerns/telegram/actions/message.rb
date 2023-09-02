# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Telegram
  module Actions
    # Обработчик сообщений (def message)
    #
    module Message
      # Поменяли в проекте имя
      #  {"message_id":19,"from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},"chat":{"id":-1001927279455,"title":"Группа поддержи моего проекта","is_forum":true,"type":"supergroup"},"date":1693040081,"new_chat_title":"Группа поддержи моего проекта"}
      def message(data)
        if direct_client_message?
          client_message data
        else
          operator_message data
        end
      end

      private

      def operator_message(data)
        if data.key? 'new_chat_title'
          # Старое название data.dig('chat', 'title')
          chat_project&.update! telegram_group_name: data.fetch('new_chat_title'), name: data.fetch('new_chat_title')
        elsif forum_topic_action? # Так это мы его сами и создали
          # Skip
        elsif topic_message?
          operator_topic_message(data)
        elsif forum?
          # Skip
        elsif chat['type'] == 'group' # Похоже пишут в главном топике группы, возможно надо проверять еще на chat['supergroup']
          # Skip
        elsif data.key? 'migrate_from_chat_id' # The supergroup has been migrated from a group with the specified identifier.
          # {"message_id"=>1,
          # "from"=>{"id"=>1087968824, "is_bot"=>true, "first_name"=>"Group", "username"=>"GroupAnonymousBot"},
          # "sender_chat"=>{"id"=>-1001666935694, "title"=>"Test", "type"=>"supergroup"},
          # "chat"=>{"id"=>-1001666935694, "title"=>"Test", "type"=>"supergroup"},
          # "date"=>1692960088,
          # "migrate_from_chat_id"=>-933474784}
          respond_with :message, text: "Прекрассно!\nТеперь это супер-группа!\nОсталось дать мне право управлять темами."
        else
          respond_with :message, text: 'Пока со мной напрямую разговаривать нет смысла, пишите в группе'
        end
      end

      def client_message(data)
        # TODO: Если это ответ, то посылать в конкретный проект
        visitor = last_used_visitor
        if visitor.present?
          ForwardClientMessageJob.perform_later visitor, data
        else
          # TODO: Задавать вопрос с какго сайта?
          # Если это кастомный бот, то мы знаем откуда и можно сразу форвардить вопрос к оператору
          respond_with :message, text: 'Ой, а мы с вами не знакомы :*'
        end
      end

      # Сообщение оператора в теме
      #
      def operator_topic_message(data)
        if chat_project.present?
          if topic_visitor.present?
            ForwardOperatorMessageJob.perform_later topic_visitor, data
          else
            reply_with :message, text: 'Не нашел посетителя прикрепленного к этому треду :*'
          end
        else
          reply_with :message, text: 'Не пойму что за группа в которую я подключен. Проект не найден'
        end
      end
    end
  end
end
