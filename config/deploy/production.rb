# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

host = ENV.fetch('DEPLOY_HOST', 'samochat.ru')
set :application, host
server host,
       user: fetch(:user),
       port: '22',
       primary: true,
       roles: %w[web app sidekiq db].freeze
