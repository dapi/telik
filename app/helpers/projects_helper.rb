# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module ProjectsHelper
  def bot_connection_status(project)
    errors = []
    errors << 'Включите в группе топики' unless project.telegram_group_type == 'supergroup' && project.telegram_group_is_forum

    if project.bot_status == 'administrator'
      errors << 'Дайте боту доступ управлять топиками' unless project.bot_can_manage_topics?
    else
      errors << 'Сделайте бота администратором и дайте доступ управлять топиками'
    end
    if errors.any?
      content_tag :span, errors.join(', '), class: 'badge bg-danger'
    else
      content_tag :span, 'OK', class: 'badge bg-success'
    end
  end
end
