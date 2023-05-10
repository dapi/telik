# frozen_string_literal: true

lock '3.16'
set :application, 'telikbot.ru'
set :user, 'app'
set :deploy_to, -> { "/home/#{fetch(:user)}/#{fetch(:application)}" }

set :linked_files, %w[.env config/master.key]

# Defaults
set :linked_dirs,
    fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Defaults
# set :assets_dependencies, %w(app/assets lib/assets vendor/assets Gemfile.lock config/routes.rb)

desc 'Setup deploy'
task setup: ['master_key:setup', 'puma:install', 'systemd:sidekiq:setup', 'telegram:bot:set_webhook']
