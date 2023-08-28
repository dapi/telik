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

  private

  def records
    super.joins(:visitor_session).where(visitor_sessions: { project_id: project.id })
  end

  def project
    @project ||= current_user.projects.find params[:project_id]
  end
end
