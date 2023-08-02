# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Временные хелперы.
# Помогают попробовать как работают ссылки на бота с пользовательского сайта
module VisitHelper
  def telegram_link(user: {}, visit: {}, page: {})
    render 'widget', project_key: default_project_key, user:, visit:, page:, use_asset_digest: true
  rescue ActiveRecord::RecordNotFound
    'Не найден проект'
  end

  # Это пример поэтому берем первый попавшийся ключ
  # Но в жизни пользователь должен тут подставлять ключ своего проекта
  #
  def default_project_key
    Project.find_by!(host: request.host).key
  end
end
