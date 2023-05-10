# frozen_string_literal: true

set :stage, :production
set :rails_env, :production
fetch(:default_env)[:rails_env] = :production
fetch(:default_env)[:tld_length] = 1

server 'telikbot.ru',
       user: fetch(:user),
       port: '22',
       primary: true,
       roles: %w[web app sidekiq db].freeze
