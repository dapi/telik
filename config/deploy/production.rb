# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

server 'nuichat.ru',
       user: fetch(:user),
       port: '22',
       primary: true,
       roles: %w[web app sidekiq db].freeze
