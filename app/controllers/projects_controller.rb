# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Управление опреаторскими проектами
class ProjectsController < ApplicationController
  def show
    project = current_user.projects.find(params[:id])
    render locals: {
      project:
    }
  end

  def new
    render locals: {
      project: Project.new(permitted_params)
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

  def permitted_params
    params.fetch(:project, {}).permit(:url, :telegram_group_id)
  end
end
