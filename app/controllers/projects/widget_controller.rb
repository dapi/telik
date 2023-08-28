# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Настройка виджета по проекту
#
class Projects::WidgetController < ApplicationController
  before_action :require_login
  before_action { @back_url = projects_path }
  layout 'simple'

  before_action do
    @header_title = project.name
  end

  # Показывает страницу настройки виджета
  def show
    render locals: { project: }
  end

  # Делает проверку на настроенность виджета и если все ок редиректит далее на настройку проекта
  def create
    if project.widget_installed?
      redirect_to project_path(project),
                  status: :see_other,
                  notice: "Виджет отлично установлен на сайт #{project.host}"
    else
      redirect_to project_widget_path(project),
                  status: :see_other,
                  alert: 'Проверка не прошла. Установите виджет на сайт и воспользуйтемь им сами хотя бы однажды.'
    end
  end

  private

  def project
    @project ||= current_user.projects.find params[:project_id]
  end
end
