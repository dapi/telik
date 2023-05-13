# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Пушает в канал изменения проекта
#
class ProjectRelayJob < ApplicationJob
  queue_as :default

  def perform(project)
    project.memberships.pluck(:user_id).each do |user_id|
      ProjectsChannel.broadcast_to(
        user_id,
        project: Project.last.as_json,
        row: ProjectsController.render(partial: 'projects/project', locals: { project: })
      )
    end
  end
end
