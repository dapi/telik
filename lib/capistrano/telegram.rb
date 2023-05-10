# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

desc 'Set webhook urls for all bots'
namespace :telegram do
  namespace :bot do
    task :set_webhook  do
      on primary(:app) do
        within current_path do
          with rails_env: fetch(:rails_env) do
            rake 'telegram:bot:set_webhook'
          end
        end
      end
    end
  end
end
