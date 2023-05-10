# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Базовый класс job-ов
class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  include Rails.application.routes.url_helpers

  class << self
    def default_url_options
      Rails.application.config.action_controller.default_url_options
    end
  end
end
