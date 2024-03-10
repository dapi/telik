# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Пускает только админов
class AdminRestriction
  def initialize(app)
    @app = app
  end

  def call(env)
    user_id = env['rack.session'][:user_id]
    if user_id
      user = User.find_by id: user_id
      if user.super_admin?
        @app.call(env)
      else
        [403, {}, ['Not authorized']]
      end
    else
      [403, {}, ['Not authenticated']]
    end
  end
end
