# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Сессия веб-посетителя по конкретному проекту
#
class VisitorSession < ApplicationRecord
  belongs_to :project

  # Устанавливается после контакта через телегу
  belongs_to :visitor, optional: true

  has_many :visits, dependent: :delete_all
  has_one :last_visit, -> { order('created_at asc') }, class_name: 'Visit', dependent: :nullify, inverse_of: :visitor_session
  has_one :first_visit, -> { order('created_at asc') }, class_name: 'Visit', dependent: :nullify, inverse_of: :visitor_session

  validates :cookie_id, presence: true
end
