# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Тариф ;)
class Tariff < ApplicationRecord
  has_many :projects, dependent: :restrict_with_error

  scope :ordered, -> { order :position }
  scope :alive, -> { order :archived_at }

  validates :title, presence: true, uniqueness: true
  validates :details, presence: true

  def self.free!
    where(price: 0).take!
  end
end
