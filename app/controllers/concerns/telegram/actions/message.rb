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
        ::Message
          .create_with(
            chat_id: chat.fetch('id'),
            from_telegram: true,
            payload: data)
          .create_or_find_by!(message_id: data.fetch('message_id'))
        if direct_client_message?
          client_message data
        else
          operator_message data
        end
      end

      private

      def operator_message(data) # rubocop:disable Metrics/PerceivedComplexity
        Rails.logger.info "operator_message #{data}"
        if forum_topic_created? # Так это мы его сами и создали?
          Rails.logger.info "Add skipped topic #{data}"
          chat_project&.add_skipped_topic! data.fetch('message_thread_id')
        end
        update_forum_topic! data if forum_topic_edited? # Похоже отредактировали тему, надо отразить на нашей стороне

        if data.key? 'new_chat_title'
          Rails.logger.info 'Update telegram group name'
          # Старое название data.dig('chat', 'title')
          chat_project&.update! telegram_group_name: data.fetch('new_chat_title'), name: data.fetch('new_chat_title')
        end

        if topic_message?
          operator_topic_message(data)
        elsif data.key? 'migrate_from_chat_id' # The supergroup has been migrated from a group with the specified identifier.
          # {"message_id"=>1,
          # "from"=>{"id"=>1087968824, "is_bot"=>true, "first_name"=>"Group", "username"=>"GroupAnonymousBot"},
          # "sender_chat"=>{"id"=>-1001666935694, "title"=>"Test", "type"=>"supergroup"},
          # "chat"=>{"id"=>-1001666935694, "title"=>"Test", "type"=>"supergroup"},
          # "date"=>1692960088,
          # "migrate_from_chat_id"=>-933474784}
          respond_with :message, text: "Прекрассно!\nТеперь это супер-группа!\nОсталось дать мне право управлять темами."
        elsif forum?
          # "chat"=>{"id"=>-1002113549405, "title"=>"Danil & samochat_dev_prod_bot", "is_forum"=>true, "type"=>"supergroup"},
          # Похоже что пишу в общем группе или какие-то события от телеги
          if chat_project.present?
            # TODO: ОБновлять group_type, group_is_forum
            Rails.logger.info 'Skip message to general topic'
          else
            chat_project = Project.with_bots.find_by(bot_token: bot.token)
            if chat_project.nil?
              respond_with :message, text: 'Кажись вы меня не туда добавили'
            elsif chat_project.telegram_group_id.present? && chat_project.telegram_group_id == chat.fetch('id')
              Rails.logger.info 'Strange situation'
              Bugsnag.notify 'WTF' do |b|
                b.meta_data = { chat_project:, update: }
              end
            elsif chat_project.telegram_group_id.present?
              Rails.logger.info 'Wrong group'
              respond_with :message, text: 'Кажись вы меня добавили еще в одну группу, а я так не умею'
            else
              chat_project.update!(
                name: chat.fetch('title'),
                telegram_group_id: chat.fetch('id'),
                telegram_group_name: chat.fetch('title'),
                telegram_group_is_forum: chat.fetch('is_forum'),
                telegram_group_type: chat.fetch('type')
              )
              respond_with :message, text: 'Привет! Осталось дать мне право управлять темами.'
            end
          end
        else
          notify_bugsnag 'Странное событие'
          respond_with :message, text: 'Пока со мной напрямую разговаривать нет смысла, пишите в группе'
        end
      end

      def client_message(data)
        Rails.logger.info "client_message #{data}"
        # TODO: Если это ответ, то посылать в конкретный проект
        # но для этого нужно сохранять все сообщения и искать их по-базе

        # Пример ответа
        # {
        # "message_id"=>463,
        # "from"=>{"id"=>943084337, "is_bot"=>false, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "language_code"=>"en"},
        # "chat"=>{"id"=>943084337, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "type"=>"private"},
        # "date"=>1693677761,
        # "reply_to_message"=>{
        # "message_id"=>460,
        # "from"=>{"id"=>5933409757, "is_bot"=>true, "first_name"=>"Nui Chat", "username"=>"NuiChatBot"},
        # "chat"=>{"id"=>943084337, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "type"=>"private"},
        # "date"=>1693677684,
        # "text"=>"А?"
        # },
        # "text"=>"Согласен"
        # }
        visitor = last_used_visitor
        if visitor.present?
          ForwardClientMessageJob.perform_later visitor, data
        else
          # TODO: Задавать вопрос с какго сайта?
          # Если это кастомный бот, то мы знаем откуда и можно сразу форвардить вопрос к оператору
          respond_with :message, text: 'Ой, а мы с вами не знакомы :*'
        end
      end

      # {"message_id"=>52,
      # "from"=>{"id"=>943084337, "is_bot"=>false, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "language_code"=>"en"},
      # "chat"=>{"id"=>-1001619875491, "title"=>"LocalNuiChatBot Support", "is_forum"=>true, "type"=>"supergroup"},
      # "date"=>1693755660,
      # "message_thread_id"=>5,
      # "forum_topic_edited"=>{"name"=>"Переименовалка", "icon_custom_emoji_id"=>"5312322066328853156"},
      # "is_topic_message"=>true}
      def update_forum_topic!(data)
        Rails.logger.info "update_forum_topic! #{data}"
        if topic_visitor.present?
          # {"name"=>"Переименовалка", "icon_custom_emoji_id"=>"5312322066328853156"}
          topic_visitor.update! topic_data: topic_visitor.topic_data.merge(data.fetch('forum_topic_edited'))
        else
          Bugsnag.notify 'Переименовали не известный топик' do |b|
            b.metadata = { payload: }
            b.severity = :warning
          end
        end
      end

      # Сообщение оператора в теме
      #
      def operator_topic_message(data)
        Rails.logger.info "operator_topic_message #{data}"
        if chat_project.present?
          if chat_project.skip_threads_ids.include? topic_id
            Rails.logger.warn "Skip thread #{topic_id} (#{chat_project.skip_threads_ids})"
          elsif topic_visitor.present?
            Rails.logger.info 'Touch operator_replied_at'
            topic_visitor.touch :operator_replied_at
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
