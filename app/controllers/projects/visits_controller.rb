# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Контроллер оператора для просмотра посещений
#
class Projects::VisitsController < ApplicationController
  include RansackSupport
  include PaginationSupport

  layout 'project'
  helper_method :project
  before_action :require_login

  def show
    render locals: { record: project.visits.find(params[:id]) }
  end

  private

  def records
    super.with_visitor.by_project(project.id)
  end

  def project
    @project ||= current_user.projects.find params[:project_id]
  end
end