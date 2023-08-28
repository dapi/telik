# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Telegram
  # Контроллер бота.
  #
  class WebhookController < Bot::UpdatesController
    include UpdateProjectMembership
    include Commands::Start
    include Commands::Who
    include Actions::Message
    include Actions::MyChatMember
    include Telegram::RescueErrors

    use_session!

    private

    def topic_visitor
      return if chat_project.nil?

      chat_project.visitors.find_by(telegram_message_thread_id: payload.fetch('message_thread_id'))
    end

    # Топик создан или отредактирован
    def forum_topic_action?
      payload.key?('forum_topic_created') || payload.key?('forum_topic_edited')
    end

    # Это означает что сообщение из группы, а не из личной перепики
    def forum?
      chat['is_forum']
    end

    def topic_message?
      payload['is_topic_message']
    end

    # Проект найденный по chat.id
    def chat_project
      @chat_project ||= Project.find_by(telegram_group_id: chat['id']) if forum?
    end

    def find_or_create_visitor(project)
      Visitor
        .create_or_find_by!(project:, telegram_user:)
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

    def direct_client_message?
      from['id'] == chat['id'] && !from['is_bot'] && chat['type'] == 'private'
    end
  end
end
