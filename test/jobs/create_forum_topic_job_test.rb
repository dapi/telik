# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

class CreateTopicJobTest < ActiveJob::TestCase
  test 'creates topic and save its id to telegram_message_thread_id' do
    visitor = visitors :dzen
    message_thread_id = 123
    response = { 'ok' => true, 'result' => { 'message_thread_id' => message_thread_id, 'name' => '94.232.57.6', 'icon_color' => 7_322_096 } }
    bot = MiniTest::Mock.new
    bot.expect :create_forum_topic, response, chat_id: visitor.project.telegram_group_id, name: visitor.topic_title
    Telegram.bots[:operator] = bot
    assert_not visitor.telegram_message_thread_id
    CreateForumTopicJob.perform_now(visitor)
    assert_equal message_thread_id, visitor.telegram_message_thread_id
    bot.verify
  end
end
