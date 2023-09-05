# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/json'
require 'action_dispatch'

# Middleware для приёма уведомлений от пользовательских
# телеграм ботов
class CustomTelegramBotMiddleware
  attr_reader :controller

  def initialize(controller)
    @controller = controller
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    update = request.request_parameters
    project = Project.find_by_bot_id(request.params[:custom_bot_id])

    if project.present?
      controller.dispatch(project.custom_bot, update)
    else
      Rails.logger.warn "No project found with custom_bot_id #{request.params[:custom_bot_id]}"
    end
    [200, {}, ['']]
  end

  def inspect
    "#<#{self.class.name}(#{controller&.name})>"
  end
end
