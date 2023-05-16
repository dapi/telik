# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Telegram
  # Контроллер бота.
  #
  class WebhookController < Bot::UpdatesController
    include UpdateProjectMembership
    include Start

    use_session!

    def message(data)
      Rails.logger.debug data.to_json

      if direct_client_message?
        client_message data
      else
        operator_message data
      end
    end

    def my_chat_member(data)
      # Кого-то другого добавили, не нас
      return unless data.dig('new_chat_member', 'user', 'username') == Telegram.bot.username

      chat_member = data.fetch('new_chat_member')
      user = User
             .create_with(telegram_data: from)
             .create_or_find_by!(telegram_user_id: from.fetch('id'))

      project = Project
                .create_with(owner: user, chat_member_updated_at: Time.zone.now, chat_member:, name: chat.fetch('title'))
                .create_or_find_by!(telegram_group_id: chat.fetch('id'))

      update_project_bot_member!(project:, chat_member:, user:)
    end

    private

    def find_or_create_visitor(project)
      Visitor
        .create_or_find_by!(project:, telegram_user:)
    end

    def client_message(data)
      # TODO: Если это ответ, то посылать в конкретный проект
      visitor = last_used_visitor
      if visitor.present?
        RedirectClientMessageJob.perform_later visitor, data.fetch('text')
      else
        respond_with :message, text: 'Ой, а мы с вами не знакомы :*'
      end
    end

    def last_used_visitor
      if session[:project_id] && (project = Project.find_by(id: session[:project_id]))
        visitor = telegram_user.visitors.where(project_id: project.id).take
      end
      visitor || telegram_user.visitors.order(:last_visit_at).last
    end

    def telegram_user
      @telegram_user ||= TelegramUser
                         .create_with(chat.slice(*%w[first_name last_name username]))
                         .create_or_find_by! id: chat.fetch('id')
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

    def direct_client_message?
      from['id'] == chat['id'] && !from['is_bot'] && chat['type'] == 'private'
    end
  end
end
