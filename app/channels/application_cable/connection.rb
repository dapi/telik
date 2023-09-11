# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module ApplicationCable
  # Базовый коннекшен
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    rescue_from StandardError, with: :report_error

    def connect
      self.current_user = find_verified_user
    end

    private

    def report_error(err)
      Bugsnag.notify err
    end

    def find_verified_user
      # Alternative:
      # cookies.encrypted['_paprika_session']['user_id']
      user_id = env['rack.session'][:user_id]
      verified_user = User.find_by(id: user_id)
      return verified_user if verified_user

      reject_unauthorized_connection
    end
  end
end
