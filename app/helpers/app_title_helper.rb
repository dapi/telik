# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module AppTitleHelper
  TITLES = {
    'samochat.ru' => 'СамоЧат',
    'nuichat.ru' => 'NuiChat',
    'telikbot.ru' => 'Telikbot'
  }.freeze

  def app_title
    TITLES.fetch(request.host, request.host)
  end
end
