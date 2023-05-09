# frozen_string_literal: true

# Временные хелперы.
# Помогают попробовать как работают ссылки на бота с пользовательского сайта
module VisitsHelper
  def telegram_link
    link_to v_url(pk: default_project_key) do
      image_tag 'telegram_logo.png',
                class: 'img-responsive',
                width: 50,
                height: 50,
                style: 'position:fixed;bottom:0;margin:1em;background:none;z-index:9999',
                skip_pipeline: true,
                target: '_blank'
    end
  end

  # Это пример поэтому берем первый попавшийся ключ
  # Но в жизни пользователь должен тут подставлять ключ своего проекта
  #
  def default_project_key
    Project.find_by(domain: ENV.fetch('RAILS_DEVELOPMENT_HOST', 'localhost')).fist.key
  end
end
