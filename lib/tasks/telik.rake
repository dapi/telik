# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

namespace :paprika do
  namespace :bot do
    desc 'Run poller for all known bots'
    task poller_all: :environment do
      threads = Project
        .where.not(bot_token: nil)
        .each
        .map do |project|
          system(
            {
              'PAPRIKA_BOT_TOKEN' => project.bot_token,
              'PAPRIKA_BOT_USERNAME' => project.bot_username
            },
            'rake telegram:bot:poller'
          )
        end

      threads << Thread.new do
        system 'rake telegram:bot:poller'
      end
      threads.each(&:join)
    end
  end
end
