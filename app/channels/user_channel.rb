class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'user:' + current_user.id.to_s
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def project_update
  end
end
