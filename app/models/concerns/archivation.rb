# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Архивация
#
module Archivation
  extend ActiveSupport::Concern
  included do
    scope :alive, -> { where archived_at: nil }
  end

  def alive?
    archived_at.nil?
  end

  def archived?
    archived_at.present?
  end

  def archive!
    update! archived_at: Time.zone.now if alive?
  end
end
