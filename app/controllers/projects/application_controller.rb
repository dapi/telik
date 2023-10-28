# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Projects
  #  Базовый Контроллер проекта
  class ApplicationController < ::ApplicationController
    layout 'project'
    helper_method :project
    before_action :require_login

    private

    def project
      @project ||= current_user.projects.find params[:project_id]
    end
  end
end
