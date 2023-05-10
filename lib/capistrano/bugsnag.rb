# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

if ENV['BUGSNAG_API_KEY']
  namespace :deploy do
    desc 'Notify http://bugsnag.com'
    task :notify_bugsnag do
      on roles(:bugsnag) do
        run_locally do
          execute :rake, "bugsnag:deploy BUGSNAG_API_KEY=#{ENV['BUGSNAG_API_KEY']}", '--trace'
        end
      end
    end

    after 'deploy:updated', 'notify_bugsnag'
  end
end
