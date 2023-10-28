# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Projects
  # Настройка телеграм группы по проекту
  class GroupController < ApplicationController
    before_action { @back_url = projects_path }
    layout 'simple'

    before_action do
      @header_title = project.name
    end

    # Показывает страницу настройки виджета
    def show
      render locals: { project:, messages: project.setup_errors }
    end

    # Делает проверку на настроенность бота и если все ок редиректит далее на настройку проекта
    def create
      update_chat_info! project
      if project.bot_installed?
        redirect_to project_path(project),
                    status: :see_other,
                    notice: 'Поздравляю! Бот подключен.'
      else
        redirect_to project_group_path(project),
                    status: :see_other,
                    alert: "Проверка не прошла. #{project.bot_setup_errors.join(',')}"
      end
    end

    private

    def update_chat_info!(project)
      project.update_chat_info! project.fetch_chat_info
    end
  end
end
