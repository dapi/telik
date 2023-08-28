# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module ProjectsHelper
  def bot_connection_status(project)
    if project.setup_errors.any?
      content_tag :span, 'Виджет не настроен', class: 'badge bg-warning', title: project.setup_errors.join(', ')
    else
      content_tag :span, 'OK', class: 'badge bg-success'
    end
  end
end
