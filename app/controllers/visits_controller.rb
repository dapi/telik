# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Контроллер оператора для просмотра посещений
#
class VisitsController < ApplicationController
  include RansackSupport
  include PaginationSupport
  before_action :require_login

  private

  def records
    super.joins(:visitor_session).where(visitor_sessions: { project_id: current_user.projects.pluck(:id) })
  end
end
