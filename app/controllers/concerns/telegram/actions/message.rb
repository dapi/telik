# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Telegram
  module Actions
    # Обработчик сообщений (def message)
    #
    module Message
      def message(data)
        Rails.logger.debug data.to_json

        if direct_client_message?
          client_message data
        else
          operator_message data
        end
      end

      private

      def operator_message(data)
        if forum_topic_action?
          # Так это мы его сами и создали
        elsif topic_message?
          operator_topic_message(data)
        elsif forum?
          # Возможно надо проверять еще на chat['supergroup']
          # Похоже пишут в главном топике группы
        elsif chat['type'] == 'group'
          # Возможно сообщение о добавлении пользователей
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

      def operator_topic_message(data)
        if chat_project.present?
          if topic_visitor.present?
            ClientMessageJob.perform_later topic_visitor, data.fetch('text')
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
