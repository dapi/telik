# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module AdvertDisable
  extend ActiveSupport::Concern
  included do
    scope :enabled, -> { where disabled_at: nil }
  end
  # Запрет оперератором
  #
  def disable!(reason)
    update! disable_reason: reason, disabled_at: Time.zone.now unless hidden?
  end

  def disabled?
    disabled_at.present?
  end

  def enabled?
    disabled_at.nil?
  end

  def enable!
    update! disablereason: nil, disabled_at: nil
  end
end
