# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

class RegisterVisitJobTest < ActiveJob::TestCase
  fixtures :visits

  # register a visit (update registered_at and add chat)
  #
  # create a topic if it is not exists or use saved topic if it is exists
  # send a message to the topic
  #
  # send a message to the private operator chat
  #
  test 'register visit and create topic for new visitor' do
    visit = visits :yandex
    chat = { 'id' => 943_084_337, 'first_name' => 'Danil', 'last_name' => 'Pismenny', 'username' => 'pismenny', 'type' => 'private' }

    assert_not visit.chat

    CreateForumTopicJob.stub :perform_now, ->(_visitor) { true } do
      return true
    end
    RegisterVisitJob.new.perform(visit:, chat:)

    assert visit.chat, 'Chat data must be saved'
    assert visit.registered_at, 'Visit must be registered'
  end
end
