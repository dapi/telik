# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

class UsersChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'users:' + current_user.id.to_s
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
