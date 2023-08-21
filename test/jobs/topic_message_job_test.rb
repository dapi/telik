# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'test_helper'

class TopicMessageJobTest < ActiveJob::TestCase
  fixtures :visits

  # register a visit (update registered_at and add chat)
  #
  # create a topic if it is not exists or use saved topic if it is exists
  # send a message to the topic
  #
  # send a message to the private operator chat
  #
  test 'rescue error' do
    visitor = visitors :yandex

    TopicMessageJob.new.perform(visitor, 'test')
  end
end
