# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module History
  extend ActiveSupport::Concern
  included do
    before_update do
      self.history = history_was << { at: Time.zone.now, changes: }
    end
  end
end
