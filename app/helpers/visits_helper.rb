# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Временные хелперы.
# Помогают попробовать как работают ссылки на бота с пользовательского сайта
module VisitsHelper
  def telegram_link
    render 'widget', project_key: default_project_key
  end

  # Это пример поэтому берем первый попавшийся ключ
  # Но в жизни пользователь должен тут подставлять ключ своего проекта
  #
  def default_project_key
    Project.find_by(host: ApplicationConfig.host).key
  end
end
