# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Управление опреаторскими проектами
class ProjectsController < ApplicationController
  before_action :require_login
  before_action { @back_url = root_url }

  layout 'simple'

  helper_method :project

  def show
    @header_title = project.name
    if project.setup_errors.empty?
      render locals: { project: }, layout: 'project'
    elsif !project.bot_installed?
      redirect_to project_group_path(project)
    elsif !project.widget_installed?
      redirect_to project_widget_path(project)
    end
  end

  def new
    project = current_user.projects.where(host_confirmed_at: nil).where.not(telegram_group_id: nil).take
    if project.present?
      if !project.bot_installed?
        redirect_to project_group_path(project)
      elsif !project.widget_installed?
        redirect_to project_widget_path(project)
      else
        render locals: {
          project:
        }
      end
    else
      render locals: {
        project: Project.new(permitted_params)
      }
    end
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

  def update
    project = current_user.projects.find params[:id]
    project.update! permitted_params
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

  def permitted_params
    params
      .fetch(:project, {})
      .permit(:name, :custom_username, :url, :welcome_message, :telegram_group_id, :topic_title_template, :thread_on_start, :bot_token, :tariff_id)
  end
end
