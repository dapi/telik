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

  # Сколько шагов в настройке проекта требуется
  def project_setup_steps(project)
    project.custom_bot? ? 3 : 2
  end

  def project_current_step(project) # rubocop:disable Metrics/PerceivedComplexity
    if project&.tariff&.custom_bot_allowed?
      if !project.bot_token?
        1
      elsif !project.bot_installed?
        2
      elsif !project.widget_installed?
        3
      end
    elsif !project.bot_installed?
      1
    elsif !project.widget_installed?
      2
    end
  end
end
