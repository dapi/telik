# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

class Tariff < ApplicationRecord
  has_many :projects

  scope :ordered, -> { order :position }
  scope :alive, -> { order :archived_at }

  validates :title, presence: true, uniqueness: true
  validates :details, presence: true
end
