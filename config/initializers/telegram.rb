# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

Rails.application.config.telegram_updates_controller.session_store = :redis_cache_store, { expires_in: 1.month }
