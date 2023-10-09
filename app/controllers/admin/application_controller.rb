# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  # Административный контроллер
  #
  class ApplicationController < Administrate::ApplicationController
    include Sorcery::Controller
    include Authentication

    before_action :require_login
    before_action :authenticate_admin

    private

    def authenticate_admin
      raise NotAuthorized unless current_user.super_admin?
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
