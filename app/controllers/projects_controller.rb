# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Управление опреаторскими проектами
class ProjectsController < ApplicationController
  before_action :require_login

  helper_method :back_url

  layout 'simple'

  def show
    project = Project.find params[:id]
    return not_authenticated unless project.member? current_user

    render locals: {
      project:
    }
  end

  def new
    project = Project.new(permitted_params)
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

  def back_url
    root_url
  end

  def permitted_params
    params.fetch(:project, {}).permit(:name, :custom_username, :url, :telegram_group_id)
  end
end
