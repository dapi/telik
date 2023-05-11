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
end
