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
  test "the truth" do
    visit = visits :yandex
    chat = {"id"=>943084337, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "type"=>"private"}

    assert visit.reload.chat.nil?
    RegisterVisitJob.new.perform(visit: visit, chat: chat)

    assert visit.reload.chat.present?, 'Chat data must be saved'
  end
end
