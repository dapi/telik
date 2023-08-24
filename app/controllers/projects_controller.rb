# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Управление опреаторскими проектами
class ProjectsController < ApplicationController
  before_action :require_login
  helper_method :back_url
  layout 'simple'

  helper_method :project

  def show
    if project.setup_errors.empty?
      render locals: {
        project:
      }, layout: 'project'
    elsif !project.widget_installed?
      redirect_to project_widget_path(project)
    elsif !project.bot_installed?
      redirect_to bot_setup_project_path(project)
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
