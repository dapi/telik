# frozen_string_literal: true

server 'telikbot.ru',
       user: fetch(:user),
       port: '22',
       primary: true,
       roles: %w[web app sidekiq db].freeze
