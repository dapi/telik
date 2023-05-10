# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

set :systemd_sidekiq_role, :sidekiq
set :systemd_sidekiq_instances, -> { %i[1] }

after 'deploy:publishing', 'systemd:sidekiq:reload-or-restart' unless ENV['SKIP_SIDEKIQ_RESTART']

namespace :sidekiq do
  task :quit do
    on roles(:sidekiq) do
      execute :systemctl, "--user kill -s TSTP #{fetch(:application)}_sidekiq.slice"
    end
  end
end

# TODO: не нужно делать при первом деплое
# after 'deploy:starting', 'sidekiq:quit'
