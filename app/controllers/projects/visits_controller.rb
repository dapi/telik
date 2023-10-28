# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Projects
  # Контроллер оператора для просмотра посещений
  #
  class VisitsController < ApplicationController
    include RansackSupport
    include PaginationSupport

    def show
      render locals: { record: project.visits.find(params[:id]) }
    end

    private

    def records
      super.with_visitor.by_project(project.id)
    end
  end
end
