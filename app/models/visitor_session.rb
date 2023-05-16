# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Сессия веб-посетителя по конкнетному проекту
#
class VisitorSession < ApplicationRecord
  belongs_to :project

  # Устанавливается после контакта через телегу
  belongs_to :visitor, optional: true

  has_many :visits, dependent: :delete_all
  has_one :last_visit, class_name: 'Visit', dependent: :nullify, through: :visitor_sessions
  has_one :first_visit, class_name: 'Visit', dependent: :nullify, through: :visitor_sessions

  validates :cookie_id, presence: true
end
