# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Настройка телеграм группы по проекту
class Projects::GroupController < ApplicationController
  before_action :require_login
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
    if project.bot_installed?
      redirect_to project_path(project),
                  status: :see_other,
                  notice: 'Поздравляю! Бот подключен.'
    else
      redirect_to project_bot_path(project),
                  status: :see_other,
                  alert: "Проверка не прошла. #{project.bot_setup_errors.join(',')}"
    end
  end

  private

  def project
    @project ||= current_user.projects.find params[:project_id]
  end
end
