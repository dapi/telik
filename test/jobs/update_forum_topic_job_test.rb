# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

class UpdateTopicJobTest < ActiveJob::TestCase
  test 'update topic and save its id to telegram_message_thread_id' do
    visitor = visitors :dzen
    visitor.telegram_message_thread_id = Random.rand(1..100_000)
    response = { 'ok' => true, 'result' => true }
    bot = MiniTest::Mock.new
    bot.expect :edit_forum_topic, response,
               message_thread_id: visitor.telegram_message_thread_id,
               chat_id: visitor.project.telegram_group_id,
               name: String
    Telegram.stub :bot, bot do
      UpdateForumTopicJob.perform_now(visitor)
    end
    bot.verify
  end
end
