# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Telegram
  # Команда /start
  #
  module Start
    def start!(visit_key = nil, *_args)
      if visit_key.to_s.start_with?(Visit::TELEGRAM_KEY_PREFIX) && (visit = Visit.includes(:visitor).find_by_telegram_key visit_key)
        start_visit! visit
      elsif (visitor = last_used_visitor)
        start_visit! auto_create_visit visitor
      elsif (user = User.find_by(telegram_user_id: chat.fetch('id')))
        respond_with :message, text: "Привет, #{user.public_name}! Следуйте по ссылке #{Rails.application.routes.url_helpers.root_url}"
      else
        respond_with :message, text:
          ["Привет, #{user.public_name}!",
           'Это сервис для поддержки пользователей через телеграм',
           "Чтобы подключиться следуйте по ссылке #{Rails.application.routes.url_helpers.root_url}"].join("\n")
      end
    end

    private

    def start_visit!(visit)
      if visit.visitor_session.visitor_id.nil?
        visit.visitor_session.with_lock do
          visit.visitor_session.update! visitor: find_or_create_visitor(visit.visitor_session.project)
        end
      end

      session[:project_id] = visit.project.id
      RegisterVisitJob.perform_later(visit:, chat:)
      respond_with :message, text: visit.visitor_session.project.username + ": Привет, #{telegram_user.first_name}! Чем вам помочь?"
    end
  end
end
