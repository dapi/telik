#!/usr/bin/env puma
# frozen_string_literal: true

APP_ROOT = Dir.pwd.gsub(%r{/releases/\d+}, '')

raise 'No shared directory' unless Dir.exist? "#{APP_ROOT}/shared"

SHARED_DIR = "#{APP_ROOT}/shared".freeze
CURRENT_DIR = "#{APP_ROOT}/current".freeze

directory CURRENT_DIR
rackup "#{CURRENT_DIR}/config.ru"

environment ENV.fetch('RAILS_ENV')

silence_single_worker_warning unless ENV.fetch('RAILS_ENV') == 'production'

tag 'puma'

pidfile "#{SHARED_DIR}/tmp/pids/puma.pid"
state_path "#{SHARED_DIR}/tmp/pids/puma.state"
stdout_redirect "#{SHARED_DIR}/log/puma_access.log", "#{SHARED_DIR}/log/puma_error.log", true

if ENV.key? 'CONTROL_BIND'
  activate_control_app ENV.fetch('CONTROL_BIND', 'tcp://127.0.0.1:9294'),
                       { auth_token: ENV.fetch('CONTROL_AUTH_TOKEN', 'CHANGEME') }
end

bind "unix://#{SHARED_DIR}/tmp/sockets/puma.sock"
bind "tcp://0.0.0.0:#{ENV['PORT']}" if ENV['PORT']

preload_app! false

prune_bundler

on_restart do
  Rails.logger.debug 'Refreshing Gemfile'
  ENV['BUNDLE_GEMFILE'] = "#{CURRENT_DIR}/Gemfile"
end

lowlevel_error_handler do |err|
  warn err
  warn err.backtrace
  Bugsnag.notify(err)
  [500, {}, ['An error has occurred']]
end
