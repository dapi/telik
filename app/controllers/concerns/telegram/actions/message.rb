# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Telegram
  module Actions
    # Обработчик сообщений (def message)
    #
    module Message
      # Поменяли в проекте имя
      # {
      # "message_id":19,
      # "from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},
      # "chat":{"id":-1001927279455,"title":"Группа поддержи моего проекта","is_forum":true,"type":"supergroup"},
      # "date":1693040081,
      # "new_chat_title":"Группа поддержи моего проекта"
      # }
      def message(data)
        respond_with :message, text: 'Пока со мной напрямую разговаривать нет смысла'
      end
    end
  end
end
