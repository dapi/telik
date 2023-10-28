# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Projects
  # Посетители проекта
  #
  class VisitorsController < ApplicationController
    include RansackSupport
    include PaginationSupport

    def show
      render locals: { record: project.visitors.find(params[:id]) }
    end

    private

    def records
      super.where(project_id: project.id)
    end
  end
end
