# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Управление опреаторскими проектами
class ProjectsController < ApplicationController
  before_action :require_login

  helper_method :back_url

  layout 'simple'

  def show
    if project.widget_installed?
      render locals: {
        project:
      }
    else
      redirect_to widget_setup_project_path(project)
    end
  end

  def new
    project = Project.new(permitted_params.reverse_merge(name: 'Безымянный #' + current_user.projects.count + 1))
    render locals: {
      project:
    }
  end

  def create
    project = current_user.projects.build owner: current_user
    project.assign_attributes permitted_params
    project.save!
    redirect_to project_path(project)
  rescue ActiveRecord::RecordInvalid => e
    render :new, locals: {
      project: e.record
    }
  end

  def widget_setup
    render locals: { project: }
  end

  def widget_check
    if project.host_confirmed?
      redirect_to project_path(project),
                  status: :see_other,
                  notice: "Виджет отлично установлен на сайт #{project.host}"
    else
      redirect_to widget_setup_project_path(project),
                  status: :see_other,
                  alert: 'Проверка не прошла. Установите виджет на сайт и воспользуйтемь им сами хотя бы однажды.'
    end
  end

  private

  def project
    @project ||= current_user.projects.find params[:id]
  end

  def back_url
    root_url
  end

  def permitted_params
    params.fetch(:project, {}).permit(:name, :custom_username, :url, :telegram_group_id)
  end
end
