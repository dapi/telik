# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Тариф ;)
class Tariff < ApplicationRecord
  has_many :projects, dependent: :restrict_with_exception_with_error

  scope :ordered, -> { order :position }
  scope :alive, -> { order :archived_at }

  validates :title, presence: true, uniqueness: true
  validates :details, presence: true
end
