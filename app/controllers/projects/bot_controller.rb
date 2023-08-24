# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Настройка бота по проекту
class Projects::BotController < ApplicationController
  before_action :require_login
  helper_method :back_url
  layout 'simple'

  # Показывает страницу настройки виджета
  def show
    render locals: { project: }
  end

  # Делает проверку на настроенность бота и если все ок редиректит далее на настройку проекта
  def create
    if project.bot_installed?
      redirect_to project_path(project),
                  status: :see_other,
                  notice: 'Поздравляю! Бот подключен.'
    else
      redirect_to bot_project_path(project),
                  status: :see_other,
                  alert: 'Проверка не прошла. Настройте супер-группу и подключите в нее бота по инструкции.'
    end
  end

  private

  def project
    @project ||= current_user.projects.find params[:project_id]
  end

  def back_url
    root_url
  end
end
